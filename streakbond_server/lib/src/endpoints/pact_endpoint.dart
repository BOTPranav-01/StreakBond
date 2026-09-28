import 'dart:math';

import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Core endpoint for managing pacts, check-ins, and streaks.
/// All methods require authentication.
class PactEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Creates a new pact with a generated invite code.
  /// The creator becomes the owner; the pact starts in 'pending' status.
  Future<Pact> createPact(
    Session session,
    String title,
    String windowStartUtc,
    String windowEndUtc,
  ) async {
    final titleTrimmed = title.trim();
    if (titleTrimmed.isEmpty || titleTrimmed.length > 100) {
      throw Exception('Title must be between 1 and 100 characters.');
    }
    if (!_isValidTimeFormat(windowStartUtc) ||
        !_isValidTimeFormat(windowEndUtc)) {
      throw Exception('Time must be in HH:mm format.');
    }
    if (windowStartUtc.compareTo(windowEndUtc) >= 0) {
      throw Exception('Window start must be before window end.');
    }

    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final pact = Pact(
      title: titleTrimmed,
      ownerId: userId,
      inviteCode: _generateInviteCode(),
      status: PactStatus.pending,
      streak: 0,
      bestStreak: 0,
      checkInWindowStartUtc: windowStartUtc,
      checkInWindowEndUtc: windowEndUtc,
      createdAt: DateTime.now().toUtc(),
    );

    return await Pact.db.insertRow(session, pact);
  }

  /// Partner accepts a pact by entering its invite code.
  /// Sets status to 'active' and assigns partnerId.
  Future<Pact> acceptPact(Session session, String inviteCode) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final pact = await Pact.db.findFirstRow(
      session,
      where: (p) => p.inviteCode.equals(inviteCode),
    );

    if (pact == null) throw Exception('Pact not found.');
    if (pact.status != PactStatus.pending)
      throw Exception('Pact is not pending.');
    if (pact.ownerId == userId)
      throw Exception('You cannot accept your own pact.');

    pact.partnerId = userId;
    pact.status = PactStatus.active;

    final updatedPact = await Pact.db.updateRow(session, pact);

    await _broadcastEvent(
      session,
      pact.ownerId,
      PactEvent(
        pactId: pact.id!,
        eventType: 'pactAccepted',
        streak: pact.streak,
        message: 'Your partner has accepted the pact!',
      ),
    );

    return updatedPact;
  }

  /// Idempotent daily check-in. Returns true if this is a new check-in.
  /// When both users have checked in today, increments the streak and
  /// broadcasts 'streakUp' to both users.
  Future<bool> checkIn(Session session, int pactId) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final pact = await Pact.db.findById(session, pactId);
    if (pact == null) throw Exception('Pact not found.');
    if (pact.ownerId != userId && pact.partnerId != userId) {
      throw Exception('Not authorized for this pact.');
    }
    if (pact.status != PactStatus.active) {
      throw Exception('Pact is not active.');
    }

    final today = _todayUtc();

    try {
      await CheckIn.db.insertRow(
        session,
        CheckIn(
          pactId: pactId,
          userId: userId,
          day: today,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    } catch (e) {
      // Idempotency: Ignore unique constraint violation
      return false;
    }

    final count = await CheckIn.db.count(
      session,
      where: (c) => c.pactId.equals(pactId) & c.day.equals(today),
    );

    if (count == 2) {
      pact.streak += 1;
      if (pact.streak > pact.bestStreak) {
        pact.bestStreak = pact.streak;
      }
      await Pact.db.updateRow(session, pact);

      final event = PactEvent(
        pactId: pactId,
        eventType: 'streakUp',
        streak: pact.streak,
        message: 'Both checked in! Streak is now ${pact.streak}.',
      );

      await _broadcastEvent(session, pact.ownerId, event);
      if (pact.partnerId != null) {
        await _broadcastEvent(session, pact.partnerId!, event);
      }
    } else if (count == 1) {
      final otherUserId = pact.ownerId == userId
          ? pact.partnerId
          : pact.ownerId;
      if (otherUserId != null) {
        await _broadcastEvent(
          session,
          otherUserId,
          PactEvent(
            pactId: pactId,
            eventType: 'partnerCheckedIn',
            streak: pact.streak,
            message: 'Your partner has checked in today!',
          ),
        );
      }
    }

    return true;
  }

  /// Returns all pacts where the user is owner or partner.
  Future<List<Pact>> getMyPacts(Session session) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    return await Pact.db.find(
      session,
      where: (p) => p.ownerId.equals(userId) | p.partnerId.equals(userId),
      orderBy: (p) => p.createdAt.desc(),
    );
  }

  /// Breaks a pact. Sets status to 'broken'.
  Future<bool> breakPact(Session session, int pactId) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final pact = await Pact.db.findById(session, pactId);
    if (pact == null) throw Exception('Pact not found.');
    if (pact.ownerId != userId && pact.partnerId != userId) {
      throw Exception('Not authorized for this pact.');
    }

    pact.status = PactStatus.broken;
    await Pact.db.updateRow(session, pact);

    final otherUserId = pact.ownerId == userId ? pact.partnerId : pact.ownerId;
    if (otherUserId != null) {
      await _broadcastEvent(
        session,
        otherUserId,
        PactEvent(
          pactId: pactId,
          eventType: 'pactBroken',
          streak: pact.streak,
          message: 'Pact was broken by your partner.',
        ),
      );
    }

    return true;
  }

  /// Returns check-in history for a pact.
  Future<List<CheckIn>> getCheckInHistory(Session session, int pactId) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final pact = await Pact.db.findById(session, pactId);
    if (pact == null) throw Exception('Pact not found.');
    if (pact.ownerId != userId && pact.partnerId != userId) {
      throw Exception('Not authorized for this pact.');
    }

    return await CheckIn.db.find(
      session,
      where: (c) => c.pactId.equals(pactId),
      orderBy: (c) => c.day.asc(),
    );
  }

  /// Returns today's check-in count for a specific pact.
  Future<int> getTodayCheckInCount(Session session, int pactId) async {
    final today = _todayUtc();
    return await CheckIn.db.count(
      session,
      where: (c) => c.pactId.equals(pactId) & c.day.equals(today),
    );
  }

  /// Checks if the current user has checked in today for a specific pact.
  Future<bool> hasCheckedInToday(Session session, int pactId) async {
    final userId = session.authenticated?.userIdentifier;
    if (userId == null) throw Exception('Not authenticated');

    final today = _todayUtc();
    final count = await CheckIn.db.count(
      session,
      where: (c) =>
          c.pactId.equals(pactId) &
          c.userId.equals(userId) &
          c.day.equals(today),
    );
    return count > 0;
  }

  // HELPER: Generate a unique invite code
  String _generateInviteCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random.secure();
    final code = List.generate(
      4,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
    return 'BOND-$code';
  }

  // HELPER: Validate HH:mm time format
  bool _isValidTimeFormat(String time) {
    final regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
    return regex.hasMatch(time);
  }

  // HELPER: Get today's date string in UTC
  String _todayUtc() {
    final now = DateTime.now().toUtc();
    return '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}';
  }

  // HELPER: Broadcast a PactEvent to a specific user
  Future<void> _broadcastEvent(
    Session session,
    String userId,
    PactEvent event,
  ) async {
    await session.messages.postMessage('user_$userId', event);
  }
}

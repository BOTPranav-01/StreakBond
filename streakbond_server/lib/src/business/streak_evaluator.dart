import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// Evaluates all active pacts and resets streaks when the check-in
/// window closes without both users checking in.
///
/// This is the showcase feature: the 'midnight streak-killer'.
/// Runs periodically via a Timer in server.dart.
class StreakEvaluator {
  // Tracks which pact+day combinations have been evaluated to prevent duplicate processing
  static final Set<String> _evaluatedDays = {};

  /// Evaluates all active pacts whose check-in window has closed.
  /// For any pact with fewer than 2 check-ins today, resets the streak
  /// to zero and broadcasts 'streakLost' to both users.
  static Future<void> evaluateAllPacts(Serverpod pod) async {
    final session = await pod.createSession();
    try {
      final now = DateTime.now().toUtc();
      final todayStr = _formatDate(now);
      final currentTime = _formatTime(now);

      // Find all active pacts
      final activePacts = await Pact.db.find(
        session,
        where: (p) => p.status.equals(PactStatus.active),
      );

      for (final pact in activePacts) {
        // Check if already evaluated today
        final evaluationKey = '${pact.id}_$todayStr';
        if (_evaluatedDays.contains(evaluationKey)) {
          continue;
        }

        // Only evaluate pacts whose window has closed
        // (current UTC time is past the window end)
        if (currentTime.compareTo(pact.checkInWindowEndUtc) < 0) {
          continue;
        }

        // Count today's check-ins for this pact
        final checkInCount = await CheckIn.db.count(
          session,
          where: (c) => c.pactId.equals(pact.id!) & c.day.equals(todayStr),
        );

        // If both checked in, nothing to do, just mark as evaluated
        if (checkInCount >= 2) {
          _evaluatedDays.add(evaluationKey);
          continue;
        }

        // STREAK DEATH: fewer than 2 check-ins after window closed
        final previousStreak = pact.streak;
        pact.streak = 0;
        await Pact.db.updateRow(session, pact);

        _evaluatedDays.add(evaluationKey);

        session.log(
          'STREAK KILLED: Pact ${pact.id} "${pact.title}" '
          'streak $previousStreak -> 0 ($checkInCount/2 check-ins)',
          level: LogLevel.warning,
        );

        // Broadcast streak death to both users
        final event = PactEvent(
          pactId: pact.id!,
          eventType: 'streakLost',
          streak: 0,
          message: 'Streak lost! Only $checkInCount/2 checked in today.',
        );

        await session.messages.postMessage('user_${pact.ownerId}', event);
        if (pact.partnerId != null) {
          await session.messages.postMessage('user_${pact.partnerId}', event);
        }
      }

      // Cleanup old entries
      _evaluatedDays.removeWhere((key) => !key.endsWith(todayStr));
    } finally {
      await session.close();
    }
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

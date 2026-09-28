import 'package:test/test.dart';
import 'package:streakbond_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given StreakBond Pact and Streak System', (
    sessionBuilder,
    endpoints,
  ) {
    late TestSessionBuilder sessionUserA;
    late TestSessionBuilder sessionUserB;

    setUp(() {
      sessionUserA = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'user_alpha_123',
          {},
        ),
      );
      sessionUserB = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          'user_beta_456',
          {},
        ),
      );
    });

    test('Full lifecycle: create -> accept -> mutual check-in -> streak increments', () async {
      // 1. User A creates a pact
      final createdPact = await endpoints.pact.createPact(
        sessionUserA,
        '20 Pushups',
        '00:00',
        '23:59',
      );

      expect(createdPact.title, '20 Pushups');
      expect(createdPact.ownerId, 'user_alpha_123');
      expect(createdPact.partnerId, isNull);
      expect(createdPact.status, PactStatus.pending);
      expect(createdPact.streak, 0);
      expect(createdPact.inviteCode, startsWith('BOND-'));

      // 2. User B accepts the pact using the invite code
      final acceptedPact = await endpoints.pact.acceptPact(
        sessionUserB,
        createdPact.inviteCode,
      );

      expect(acceptedPact.id, createdPact.id);
      expect(acceptedPact.partnerId, 'user_beta_456');
      expect(acceptedPact.status, PactStatus.active);

      // 3. User A checks in (1/2 check-ins)
      final checkInA1 = await endpoints.pact.checkIn(
        sessionUserA,
        createdPact.id!,
      );
      expect(checkInA1, isTrue);

      final countAfterA = await endpoints.pact.getTodayCheckInCount(
        sessionUserA,
        createdPact.id!,
      );
      expect(countAfterA, 1);

      // Streak remains 0 until both check in
      var myPacts = await endpoints.pact.getMyPacts(sessionUserA);
      var currentPact = myPacts.firstWhere((p) => p.id == createdPact.id);
      expect(currentPact.streak, 0);

      // 4. Idempotency test: User A checking in again on same day should return false
      final checkInA2 = await endpoints.pact.checkIn(
        sessionUserA,
        createdPact.id!,
      );
      expect(checkInA2, isFalse);

      // 5. User B checks in (2/2 mutual check-ins!)
      final checkInB = await endpoints.pact.checkIn(
        sessionUserB,
        createdPact.id!,
      );
      expect(checkInB, isTrue);

      final countAfterB = await endpoints.pact.getTodayCheckInCount(
        sessionUserB,
        createdPact.id!,
      );
      expect(countAfterB, 2);

      // Streak must now be 1!
      myPacts = await endpoints.pact.getMyPacts(sessionUserA);
      currentPact = myPacts.firstWhere((p) => p.id == createdPact.id);
      expect(currentPact.streak, 1);
      expect(currentPact.bestStreak, 1);

      // Verify check-in history has 2 records
      final history = await endpoints.pact.getCheckInHistory(
        sessionUserA,
        createdPact.id!,
      );
      expect(history.length, 2);
    });

    test('Validation prevents invalid pacts', () async {
      // Empty title should fail
      expect(
        () => endpoints.pact.createPact(sessionUserA, '', '06:00', '22:00'),
        throwsA(isA<Exception>()),
      );

      // Invalid start > end window should fail
      expect(
        () => endpoints.pact.createPact(sessionUserA, 'Read', '22:00', '06:00'),
        throwsA(isA<Exception>()),
      );

      // Creator cannot accept their own pact
      final pact = await endpoints.pact.createPact(
        sessionUserA,
        'Self Pact',
        '06:00',
        '22:00',
      );
      expect(
        () => endpoints.pact.acceptPact(sessionUserA, pact.inviteCode),
        throwsA(isA<Exception>()),
      );
    });
  });
}

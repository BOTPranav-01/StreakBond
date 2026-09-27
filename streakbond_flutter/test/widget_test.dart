import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streakbond_flutter/theme/streak_theme.dart';
import 'package:streakbond_flutter/widgets/check_in_button.dart';
import 'package:streakbond_flutter/widgets/countdown_ring.dart';
import 'package:streakbond_flutter/widgets/flame_icon.dart';
import 'package:streakbond_flutter/widgets/glassmorphism_card.dart';
import 'package:streakbond_flutter/widgets/partner_status_dot.dart';
import 'package:streakbond_flutter/widgets/streak_counter.dart';

void main() {
  testWidgets('Renders StreakBond core widgets and design system components', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildStreakTheme(),
        home: Scaffold(
          body: Column(
            children: [
              const StreakCounter(streak: 7),
              const FlameIcon(streak: 7),
              const CountdownRing(progress: 0.5, timeRemaining: '4h 12m'),
              const PartnerStatusDot(hasCheckedIn: true),
              CheckInButton(
                onPressed: () {},
                hasCheckedIn: false,
                isWithinWindow: true,
              ),
              const GlassmorphismCard(
                child: Text('Test Card'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('7'), findsOneWidget);
    expect(find.text('4h 12m'), findsOneWidget);
    expect(find.text('CHECK IN'), findsOneWidget);
    expect(find.text('Test Card'), findsOneWidget);
  });
}

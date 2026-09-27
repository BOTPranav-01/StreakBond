import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../client.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/scanline_background.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;
  const AuthScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: client.auth.authInfoListenable,
      builder: (context, _) {
        if (client.auth.isAuthenticated) {
          return child;
        }

        return Scaffold(
          backgroundColor: StreakColors.background,
          body: ScanlineBackground(
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & Branding
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: StreakColors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: StreakColors.primary, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: StreakColors.primary.withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.bolt, size: 48, color: StreakColors.primary),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'STREAKBOND',
                        style: StreakTextStyles.displayLarge.copyWith(
                          fontSize: 36,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '"Duolingo streaks, but your friend\'s laziness can kill yours."',
                        textAlign: TextAlign.center,
                        style: StreakTextStyles.bodyMedium.copyWith(
                          color: StreakColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 36),

                      // Sign In Box
                      GlassmorphismCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'AUTHENTICATE TO ACCESS',
                              style: StreakTextStyles.labelSmall.copyWith(
                                color: StreakColors.primary,
                                letterSpacing: 2,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SignInWidget(
                              client: client,
                              onAuthenticated: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Identity verified. Access granted.'),
                                    backgroundColor: StreakColors.success,
                                  ),
                                );
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Authentication error: $error'),
                                    backgroundColor: StreakColors.danger,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Serverpod 4.0 • Zero external APIs • Local DB Auth',
                        style: StreakTextStyles.labelSmall.copyWith(
                          color: StreakColors.textSecondary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../client.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';
import '../widgets/glassmorphism_card.dart';
import '../widgets/scanline_background.dart';

class AuthScreen extends StatelessWidget {
  final Widget child;
  const AuthScreen({super.key, required this.child});

  void _showCodeHelperDialog(BuildContext context) {
    final emailController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        String? fetchedCode;
        bool isFetching = false;
        String? errorMsg;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              backgroundColor: StreakColors.surface,
              title: Text(
                'RETRIEVE VERIFICATION CODE',
                style: StreakTextStyles.displayMedium.copyWith(
                  fontSize: 16,
                  color: StreakColors.primary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your registration email to fetch the code directly from the server:',
                    style: StreakTextStyles.bodyMedium.copyWith(
                      fontSize: 13,
                      color: StreakColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    style: StreakTextStyles.bodyLarge,
                    decoration: const InputDecoration(
                      hintText: 'your-email@example.com',
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: StreakColors.primary,
                      ),
                    ),
                  ),
                  if (fetchedCode != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: StreakColors.accent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: StreakColors.accent),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SelectableText(
                            fetchedCode!,
                            style: StreakTextStyles.displayMedium.copyWith(
                              fontSize: 24,
                              color: StreakColors.accent,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.copy,
                              color: StreakColors.accent,
                            ),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: fetchedCode!),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (errorMsg != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      errorMsg!,
                      style: const TextStyle(
                        color: StreakColors.danger,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('CLOSE'),
                ),
                ElevatedButton(
                  onPressed: isFetching
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          if (email.isEmpty) return;
                          setDialogState(() {
                            isFetching = true;
                            errorMsg = null;
                          });
                          try {
                            final code = await client.authHelper
                                .getLatestVerificationCode(email);
                            setDialogState(() {
                              isFetching = false;
                              if (code != null && code.isNotEmpty) {
                                fetchedCode = code;
                              } else {
                                errorMsg =
                                    'No code generated yet for $email. Please submit the sign-up form first.';
                              }
                            });
                          } catch (e) {
                            setDialogState(() {
                              isFetching = false;
                              errorMsg = 'Failed to fetch code: $e';
                            });
                          }
                        },
                  child: isFetching
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: StreakColors.background,
                          ),
                        )
                      : const Text('FETCH CODE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo & Branding
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: StreakColors.primary.withValues(alpha: 0.1),
                          border: Border.all(
                            color: StreakColors.primary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: StreakColors.primary.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.bolt,
                          size: 48,
                          color: StreakColors.primary,
                        ),
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
                                    content: Text(
                                      'Identity verified. Access granted.',
                                    ),
                                    backgroundColor: StreakColors.success,
                                  ),
                                );
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Authentication error: $error',
                                    ),
                                    backgroundColor: StreakColors.danger,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: StreakColors.glassBorder),
                            const SizedBox(height: 8),
                            TextButton.icon(
                              onPressed: () => _showCodeHelperDialog(context),
                              icon: const Icon(
                                Icons.key,
                                size: 16,
                                color: StreakColors.accent,
                              ),
                              label: Text(
                                'FETCH VERIFICATION CODE (HACKATHON / DEMO)',
                                style: StreakTextStyles.labelSmall.copyWith(
                                  color: StreakColors.accent,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Serverpod 4.0 • Zero external APIs • Local DB Auth',
                        style: StreakTextStyles.labelSmall.copyWith(
                          color: StreakColors.textSecondary.withValues(
                            alpha: 0.6,
                          ),
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

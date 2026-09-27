import 'package:flutter/material.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';

/// Pulsing neon check-in button with ripple effect.
/// Disabled and greyed out after check-in or outside the window.
class CheckInButton extends StatefulWidget {
  const CheckInButton({
    super.key,
    required this.onPressed,
    required this.hasCheckedIn,
    this.isWithinWindow = true,
  });

  final VoidCallback onPressed;
  final bool hasCheckedIn;
  final bool isWithinWindow;

  @override
  State<CheckInButton> createState() => _CheckInButtonState();
}

class _CheckInButtonState extends State<CheckInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    // Only pulse when the button is actionable
    if (!widget.hasCheckedIn && widget.isWithinWindow) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CheckInButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hasCheckedIn || !widget.isWithinWindow) {
      _pulseController.stop();
    } else {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isActive = !widget.hasCheckedIn && widget.isWithinWindow;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glowOpacity = isActive
            ? 0.3 + (_pulseController.value * 0.3)
            : 0.0;
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: StreakColors.primary.withValues(
                        alpha: glowOpacity,
                      ),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: ElevatedButton(
          onPressed: isActive ? widget.onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.hasCheckedIn
                ? StreakColors.success.withValues(alpha: 0.2)
                : isActive
                ? StreakColors.primary
                : StreakColors.textSecondary.withValues(alpha: 0.3),
            foregroundColor: widget.hasCheckedIn
                ? StreakColors.success
                : isActive
                ? StreakColors.background
                : StreakColors.textSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(
                color: widget.hasCheckedIn
                    ? StreakColors.success
                    : isActive
                    ? StreakColors.primary
                    : StreakColors.textSecondary.withValues(alpha: 0.3),
              ),
            ),
          ),
          child: Text(
            widget.hasCheckedIn
                ? '✓  CHECKED IN'
                : isActive
                ? 'CHECK IN'
                : 'WINDOW CLOSED',
            style: StreakTextStyles.button,
          ),
        ),
      ),
    );
  }
}

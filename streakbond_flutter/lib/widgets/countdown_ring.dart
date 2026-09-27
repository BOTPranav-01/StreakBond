import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';

/// Animated countdown ring showing time remaining in today's check-in window.
/// Draws a circular progress arc with glowing neon effect.
class CountdownRing extends StatelessWidget {
  const CountdownRing({
    super.key,
    required this.progress,
    required this.timeRemaining,
    this.size = 120,
    this.strokeWidth = 4,
  });

  /// Progress from 0.0 (window just opened) to 1.0 (window closing).
  final double progress;

  /// Human-readable time remaining string (e.g. "5h 23m").
  final String timeRemaining;

  /// Diameter of the ring.
  final double size;

  /// Width of the arc stroke.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background track
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: 1.0,
              color: StreakColors.primary.withValues(alpha: 0.15),
              strokeWidth: strokeWidth,
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              progress: 1.0 - progress,
              color: progress > 0.8
                  ? StreakColors.danger
                  : StreakColors.primary,
              strokeWidth: strokeWidth,
              hasGlow: true,
            ),
          ),
          // Time remaining text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                timeRemaining,
                style: StreakTextStyles.bodyLarge.copyWith(
                  color: progress > 0.8
                      ? StreakColors.danger
                      : StreakColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'remaining',
                style: StreakTextStyles.labelSmall.copyWith(
                  color: StreakColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Custom painter for the countdown ring arc.
class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
    this.hasGlow = false,
  });

  final double progress;
  final Color color;
  final double strokeWidth;
  final bool hasGlow;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    if (hasGlow) {
      // Draw glow behind the arc
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = strokeWidth + 6
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        glowPaint,
      );
    }

    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

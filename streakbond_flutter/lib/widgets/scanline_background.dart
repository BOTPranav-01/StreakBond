import 'package:flutter/material.dart';
import '../theme/streak_colors.dart';

/// Subtle animated scanline/grid background pattern.
/// Creates the sci-fi HUD atmosphere.
class ScanlineBackground extends StatelessWidget {
  const ScanlineBackground({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Grid pattern
        Positioned.fill(
          child: CustomPaint(
            painter: _GridPainter(),
          ),
        ),
        // Main content on top
        child,
      ],
    );
  }
}

/// Draws a subtle grid pattern for the sci-fi HUD look.
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = StreakColors.primary.withValues(alpha: 0.03)
      ..strokeWidth = 0.5;

    // Horizontal scanlines every 4 pixels
    for (double y = 0; y < size.height; y += 4) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }

    // Vertical grid lines every 60 pixels
    final gridPaint = Paint()
      ..color = StreakColors.primary.withValues(alpha: 0.02)
      ..strokeWidth = 0.5;

    for (double x = 0; x < size.width; x += 60) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

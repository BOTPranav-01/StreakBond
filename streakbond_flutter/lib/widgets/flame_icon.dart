import 'package:flutter/material.dart';
import '../theme/streak_colors.dart';

/// Flame icon that grows with the streak count.
/// Small for low streaks, large and multi-layered for high streaks.
class FlameIcon extends StatelessWidget {
  const FlameIcon({
    super.key,
    required this.streak,
    this.baseSize = 24,
  });

  final int streak;
  final double baseSize;

  @override
  Widget build(BuildContext context) {
    // Scale factor: grows logarithmically with streak
    final scale = 1.0 + (streak > 0 ? (streak.clamp(1, 100) / 30.0) : 0.0);
    final size = baseSize * scale;

    // Color intensifies with streak
    final color = streak > 7
        ? StreakColors.accent
        : streak > 0
            ? StreakColors.primary
            : StreakColors.textSecondary;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow behind the flame
          if (streak > 0)
            Icon(
              Icons.local_fire_department,
              size: size + 8,
              color: color.withValues(alpha: 0.3),
            ),
          // Main flame icon
          Icon(
            Icons.local_fire_department,
            size: size,
            color: color,
          ),
        ],
      ),
    );
  }
}

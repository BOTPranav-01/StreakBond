import 'package:flutter/material.dart';
import '../theme/streak_colors.dart';
import '../theme/streak_text_styles.dart';

/// Giant animated streak counter — the hero element of the app.
/// Displays with glow effect and spring animation on value change.
class StreakCounter extends StatefulWidget {
  const StreakCounter({
    super.key,
    required this.streak,
    this.color = StreakColors.primary,
  });

  final int streak;
  final Color color;

  @override
  State<StreakCounter> createState() => _StreakCounterState();
}

class _StreakCounterState extends State<StreakCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  int _displayedStreak = 0;

  @override
  void initState() {
    super.initState();
    _displayedStreak = widget.streak;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(StreakCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.streak != widget.streak) {
      // Trigger spring animation on streak change
      _controller.forward().then((_) => _controller.reverse());
      setState(() => _displayedStreak = widget.streak);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: ShaderMask(
        shaderCallback: (bounds) {
          return RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              widget.color,
              widget.color.withValues(alpha: 0.6),
            ],
          ).createShader(bounds);
        },
        child: Text(
          '$_displayedStreak',
          style: StreakTextStyles.streakHero.copyWith(
            color: Colors.white,
            shadows: [
              Shadow(
                color: widget.color.withValues(alpha: 0.8),
                blurRadius: 40,
              ),
              Shadow(
                color: widget.color.withValues(alpha: 0.4),
                blurRadius: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

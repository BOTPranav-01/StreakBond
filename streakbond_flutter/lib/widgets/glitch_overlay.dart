import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/streak_colors.dart';

/// Full-screen red glitch flash overlay for streak death.
/// Shows a dramatic red flash with shake effect and haptic feedback.
class GlitchOverlay extends StatefulWidget {
  const GlitchOverlay({
    super.key,
    required this.show,
    required this.child,
  });

  final bool show;
  final Widget child;

  @override
  State<GlitchOverlay> createState() => _GlitchOverlayState();
}

class _GlitchOverlayState extends State<GlitchOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  void didUpdateWidget(GlitchOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _triggerGlitch();
    }
  }

  void _triggerGlitch() {
    setState(() => _visible = true);
    _controller.forward(from: 0);
    // Haptic feedback for streak death
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Shake the main content during glitch
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            if (!_visible) return child!;
            final shake = sin(_controller.value * pi * 8) * 4;
            return Transform.translate(
              offset: Offset(shake, shake / 2),
              child: child,
            );
          },
          child: widget.child,
        ),
        // Red flash overlay
        if (_visible)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return IgnorePointer(
                child: Container(
                  color: StreakColors.danger
                      .withValues(alpha: (1.0 - _controller.value) * 0.4),
                ),
              );
            },
          ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Green/grey presence dot indicating partner's check-in status.
class PartnerStatusDot extends StatelessWidget {
  const PartnerStatusDot({
    super.key,
    required this.hasCheckedIn,
    this.size = 12,
  });

  final bool hasCheckedIn;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = hasCheckedIn
        ? const Color(0xFF00FF88)
        : const Color(0xFF555555);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: hasCheckedIn
            ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
    );
  }
}

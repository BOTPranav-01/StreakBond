import 'dart:ui';
import 'package:flutter/material.dart';

/// StreakBond color palette — neo-cyber premium dark theme.
/// Near-black background, electric cyan primary, hot red danger.
class StreakColors {
  StreakColors._();

  /// Near-black background (#0A0E14)
  static const Color background = Color(0xFF0A0E14);

  /// Slightly lighter surface for cards
  static const Color surface = Color(0xFF111820);

  /// Electric cyan primary (#00F0FF)
  static const Color primary = Color(0xFF00F0FF);

  /// Acid green accent (#B4FF39)
  static const Color accent = Color(0xFFB4FF39);

  /// Hot red — ONLY for streak-death states (#FF3366)
  static const Color danger = Color(0xFFFF3366);

  /// White text
  static const Color textPrimary = Color(0xFFFFFFFF);

  /// Muted text
  static const Color textSecondary = Color(0xFF8899AA);

  /// Glassmorphism border color
  static const Color glassBorder = Color(0x3300F0FF);

  /// Glassmorphism fill color
  static const Color glassFill = Color(0x0DFFFFFF);

  /// Success green for check-in confirmed
  static const Color success = Color(0xFF00FF88);
}

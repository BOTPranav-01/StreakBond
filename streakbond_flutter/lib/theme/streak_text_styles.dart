import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// StreakBond typography — Space Grotesk for display, Inter for body.
/// The streak number is the hero: massive, glowing.
class StreakTextStyles {
  StreakTextStyles._();

  /// Giant streak counter (96px Space Grotesk, bold)
  static TextStyle streakHero = GoogleFonts.spaceGrotesk(
    fontSize: 96,
    fontWeight: FontWeight.w700,
    height: 1.0,
  );

  /// Large display heading (32px Space Grotesk)
  static TextStyle displayLarge = GoogleFonts.spaceGrotesk(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Medium display heading (24px Space Grotesk)
  static TextStyle displayMedium = GoogleFonts.spaceGrotesk(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Body text (16px Inter)
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Secondary body text (14px Inter)
  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Small label text (12px Inter)
  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0.5,
  );

  /// Button text (16px Inter, semi-bold)
  static TextStyle button = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.0,
  );
}

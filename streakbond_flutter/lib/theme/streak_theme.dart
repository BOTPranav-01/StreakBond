import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'streak_colors.dart';

/// Builds the StreakBond dark ThemeData.
/// Dark theme only — it IS the brand.
ThemeData buildStreakTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: StreakColors.background,
    colorScheme: const ColorScheme.dark(
      primary: StreakColors.primary,
      secondary: StreakColors.accent,
      surface: StreakColors.surface,
      error: StreakColors.danger,
      onPrimary: StreakColors.background,
      onSecondary: StreakColors.background,
      onSurface: StreakColors.textPrimary,
      onError: Colors.white,
    ),
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: StreakColors.textPrimary,
      ),
      headlineMedium: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: StreakColors.textPrimary,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        color: StreakColors.textPrimary,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        color: StreakColors.textSecondary,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: StreakColors.background,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.spaceGrotesk(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: StreakColors.textPrimary,
      ),
      iconTheme: const IconThemeData(color: StreakColors.primary),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: StreakColors.primary,
      foregroundColor: StreakColors.background,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: StreakColors.glassFill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StreakColors.glassBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StreakColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: StreakColors.primary, width: 2),
      ),
      labelStyle: GoogleFonts.inter(color: StreakColors.textSecondary),
      hintStyle: GoogleFonts.inter(color: StreakColors.textSecondary),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: StreakColors.primary,
        foregroundColor: StreakColors.background,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: StreakColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: StreakColors.glassBorder),
      ),
    ),
  );
}

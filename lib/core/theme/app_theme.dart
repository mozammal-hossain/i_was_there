import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App colors from design (PRD / HTML screens).
abstract class AppColors {
  static const Color primary = Color(0xFF137FEC);
  static const Color bgWarmLight = Color(0xFFFDFCFB);
  static const Color bgDarkGray = Color(0xFF101922);
  static const Color neutralDot = Color(0xFFE2E8F0);
  static const Color neutralDotDark = Color(0xFF334155);
  static const Color cardDark = Color(0xFF1E293B);
  static const Color backgroundDark = Color(0xFF0F172A);
}

ThemeData buildAppTheme({required bool isDark}) {
  final colorScheme = isDark
      ? ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.bgDarkGray,
          onSurface: const Color(0xFFE2E8F0),
          onSurfaceVariant: const Color(0xFF94A3B8),
        )
      : ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.bgWarmLight,
          onSurface: const Color(0xFF1E293B),
          onSurfaceVariant: const Color(0xFF64748B),
        );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight,
    fontFamily: GoogleFonts.inter().fontFamily,
    textTheme: GoogleFonts.interTextTheme(),
    appBarTheme: AppBarTheme(
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : const Color(0xFF0F172A),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: isDark ? const Color(0xFF1E293B).withOpacity(0.4) : Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? const Color(0xFF334155).withOpacity(0.4)
          : const Color(0xFFF1F5F9).withOpacity(0.5),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(
        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF94A3B8),
        fontSize: 17,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 8,
    ),
  );
}

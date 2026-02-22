import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App color palette derived from the I Was There logo.
///
/// Logo: terracotta circle (#753C2F) with black location pin.
/// Palette is warm, personal, minimal; no gradients.
abstract class AppColors {
  // --- Brand (from logo) ---
  /// Primary brand: logo terracotta. Use for CTAs, selected states, key UI.
  static const Color primary = Color(0xFF753C2F);
  /// Lighter terracotta for subtle backgrounds (e.g. selected chip, highlight).
  static const Color primaryLight = Color(0xFFA85D4A);
  /// Very light tint for large areas (e.g. onboarding hero background).
  static const Color primaryTint = Color(0xFFF5EDEB);
  /// On primary: text and icons on primary buttons/surfaces (logo pin = black).
  static const Color onPrimary = Color(0xFFFFFFFF);

  // --- Backgrounds ---
  /// Light mode scaffold: warm off-white.
  static const Color bgWarmLight = Color(0xFFFDFCFB);
  /// Dark mode scaffold: warm dark.
  static const Color bgDarkGray = Color(0xFF101922);
  /// Dark cards/sheets (e.g. add-edit place).
  static const Color cardDark = Color(0xFF1E293B);
  /// Darkest background (headers, full-screen dark).
  static const Color backgroundDark = Color(0xFF0F172A);

  // --- Neutrals (warm grays for dots, borders, secondary text) ---
  /// Inactive/empty state (e.g. calendar dot) — light mode.
  static const Color neutralDot = Color(0xFFE2E8F0);
  /// Inactive/empty state — dark mode.
  static const Color neutralDotDark = Color(0xFF334155);

  // --- Semantic (optional) ---
  /// Success (e.g. “present”, sync success). Warm-friendly green.
  static const Color success = Color(0xFF0D9488);
  /// Error/destructive.
  static const Color error = Color(0xFFB91C1C);
}

ThemeData buildAppTheme({required bool isDark}) {
  final colorScheme = isDark
      ? ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.bgDarkGray,
          onSurface: const Color(0xFFE2E8F0),
          onSurfaceVariant: const Color(0xFF94A3B8),
        )
      : ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.bgWarmLight,
          onSurface: const Color(0xFF1E293B),
          onSurfaceVariant: const Color(0xFF64748B),
        );

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: isDark
        ? AppColors.bgDarkGray
        : AppColors.bgWarmLight,
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
      color: isDark
          ? const Color(0xFF1E293B).withValues(alpha: 0.4)
          : Colors.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: isDark
          ? const Color(0xFF334155).withValues(alpha: 0.4)
          : const Color(0xFFF1F5F9).withValues(alpha: 0.5),
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

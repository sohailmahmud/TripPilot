import 'package:flutter/material.dart';

/// Application Color Palette
/// Professional minimalist gradient-based UI color system
/// Modern, clean, and elegant color scheme for premium apps
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============ PRIMARY COLORS - GRADIENT FOUNDATION ============
  /// Primary gradient start - Deep slate/navy
  /// Used for main actions, headers, and brand elements
  static const Color primaryLight = Color(0xFF1A237E);
  static const Color primaryDark = Color(0xFF3D5AFE);

  /// Primary gradient end - Sophisticated teal
  /// Complements primary for gradient effects
  static const Color primaryAccentLight = Color(0xFF0D47A1);
  static const Color primaryAccentDark = Color(0xFF82B1FF);

  // ============ SECONDARY COLORS - ACCENT PALETTE ============
  /// Secondary accent - Premium slate blue
  /// For secondary actions and UI accents
  static const Color secondaryLight = Color(0xFF455A64);
  static const Color secondaryDark = Color(0xFF90CAF9);

  // ============ TERTIARY COLORS - TERTIARY ACCENT ============
  /// Tertiary accent - Soft cyan
  /// For additional emphasis and highlights
  static const Color tertiaryLight = Color(0xFF006064);
  static const Color tertiaryDark = Color(0xFF4DD0E1);

  // ============ ERROR COLORS ============
  /// Error/Danger state - Sophisticated red
  /// Alerts, validation errors, destructive actions
  static const Color errorLight = Color(0xFFD32F2F);
  static const Color errorDark = Color(0xFFEF5350);

  // ============ SUCCESS COLORS ============
  /// Success state - Premium green
  /// Confirmations, positive actions, completion
  static const Color successLight = Color(0xFF1B5E20);
  static const Color successDark = Color(0xFF66BB6A);

  // ============ WARNING COLORS ============
  /// Warning state - Elegant amber
  /// Cautions, important notices, alerts
  static const Color warningLight = Color(0xFFF57F17);
  static const Color warningDark = Color(0xFFFFCA28);

  // ============ SURFACE COLORS ============
  /// Surface color - Premium light background
  /// Background for cards, elevated surfaces, content areas
  static const Color surfaceLight = Color(0xFFFAFBFC);
  static const Color surfaceDark = Color(0xFF0F1419);

  /// Surface variant - Subtle secondary background
  /// For surface hierarchy and subtle differentiation
  static const Color surfaceVariantLight = Color(0xFFF4F6F8);
  static const Color surfaceVariantDark = Color(0xFF1A1F26);

  // ============ BACKGROUND COLORS ============
  /// Background - Primary app background
  /// Main canvas for content, minimalist approach
  static const Color backgroundLight = Color(0xFFFBFCFD);
  static const Color backgroundDark = Color(0xFF0A0E14);

  /// Background secondary - Subtle background
  /// For secondary content areas
  static const Color backgroundSecondaryLight = Color(0xFFF7F9FB);
  static const Color backgroundSecondaryDark = Color(0xFF101620);

  // ============ TEXT COLORS ============
  /// Primary text - Main content text
  /// High contrast for readability
  static const Color textPrimaryLight = Color(0xFF0D1B2A);
  static const Color textPrimaryDark = Color(0xFFF5F7FA);

  /// Secondary text - Supporting text, labels
  /// Medium contrast for secondary content
  static const Color textSecondaryLight = Color(0xFF3A4A5C);
  static const Color textSecondaryDark = Color(0xFFB3BAC2);

  /// Tertiary text - Hints, placeholders
  /// Lower contrast for tertiary information
  static const Color textTertiaryLight = Color(0xFF6B7A8A);
  static const Color textTertiaryDark = Color(0xFF8A92A0);

  /// Disabled text - Disabled states
  /// Minimal contrast for disabled UI
  static const Color textDisabledLight = Color(0xFFA5AEB5);
  static const Color textDisabledDark = Color(0xFF5A6268);

  // ============ BORDER COLORS ============
  /// Border color - Primary dividers and borders
  /// Subtle but visible separation
  static const Color borderLight = Color(0xFFE2E8EF);
  static const Color borderDark = Color(0xFF2A3439);

  /// Subtle border - Minimal dividers
  /// Very subtle separation for refined look
  static const Color borderSubtleLight = Color(0xFFF0F3F7);
  static const Color borderSubtleDark = Color(0xFF1F2530);

  // ============ OVERLAY COLORS ============
  /// Overlay - Transparent overlay for modals, dialogs
  /// Professional semi-transparent dark overlay
  static const Color overlayLight = Color(0x80000000);
  static const Color overlayDark = Color(0xB3000000);

  /// Scrim - Dark overlay for bottom sheets
  /// Deep dark overlay for focus
  static const Color scrimLight = Color(0xFF000000);
  static const Color scrimDark = Color(0xFF000000);

  // ============ SEMANTIC COLORS ============
  /// Info color - Informational messages
  /// Professional blue for information
  static const Color infoLight = Color(0xFF0277BD);
  static const Color infoDark = Color(0xFF4FC3F7);

  // ============ GRADIENT COLORS - PREMIUM GRADIENTS ============
  /// Gradient start - Deep premium blue
  /// Primary gradient foundation
  static const Color gradientStartLight = Color(0xFF1A237E);
  static const Color gradientStartDark = Color(0xFF3D5AFE);

  /// Gradient end - Sophisticated teal
  /// Complementary gradient endpoint
  static const Color gradientEndLight = Color(0xFF006064);
  static const Color gradientEndDark = Color(0xFF4DD0E1);

  /// Gradient secondary start - Premium slate
  /// Alternative gradient option
  static const Color gradientSecondaryStartLight = Color(0xFF37474F);
  static const Color gradientSecondaryStartDark = Color(0xFF78909C);

  /// Gradient secondary end - Soft cyan
  /// Complementary secondary gradient
  static const Color gradientSecondaryEndLight = Color(0xFF0097A7);
  static const Color gradientSecondaryEndDark = Color(0xFF80DEEA);

  // ============ CONVENIENCE METHODS ============
  /// Get color based on brightness
  static Color getPrimary(Brightness brightness) =>
      brightness == Brightness.dark ? primaryDark : primaryLight;

  static Color getPrimaryAccent(Brightness brightness) =>
      brightness == Brightness.dark ? primaryAccentDark : primaryAccentLight;

  static Color getSecondary(Brightness brightness) =>
      brightness == Brightness.dark ? secondaryDark : secondaryLight;

  static Color getTertiary(Brightness brightness) =>
      brightness == Brightness.dark ? tertiaryDark : tertiaryLight;

  static Color getError(Brightness brightness) =>
      brightness == Brightness.dark ? errorDark : errorLight;

  static Color getSuccess(Brightness brightness) =>
      brightness == Brightness.dark ? successDark : successLight;

  static Color getWarning(Brightness brightness) =>
      brightness == Brightness.dark ? warningDark : warningLight;

  static Color getSurface(Brightness brightness) =>
      brightness == Brightness.dark ? surfaceDark : surfaceLight;

  static Color getSurfaceVariant(Brightness brightness) =>
      brightness == Brightness.dark ? surfaceVariantDark : surfaceVariantLight;

  static Color getBackground(Brightness brightness) =>
      brightness == Brightness.dark ? backgroundDark : backgroundLight;

  static Color getTextPrimary(Brightness brightness) =>
      brightness == Brightness.dark ? textPrimaryDark : textPrimaryLight;

  static Color getTextSecondary(Brightness brightness) =>
      brightness == Brightness.dark ? textSecondaryDark : textSecondaryLight;

  static Color getTextTertiary(Brightness brightness) =>
      brightness == Brightness.dark ? textTertiaryDark : textTertiaryLight;

  static Color getBorder(Brightness brightness) =>
      brightness == Brightness.dark ? borderDark : borderLight;

  static Color getBorderSubtle(Brightness brightness) =>
      brightness == Brightness.dark ? borderSubtleDark : borderSubtleLight;

  static Color getInfo(Brightness brightness) =>
      brightness == Brightness.dark ? infoDark : infoLight;

  /// Get gradient colors based on brightness
  static List<Color> getGradient(Brightness brightness) => [
    brightness == Brightness.dark ? gradientStartDark : gradientStartLight,
    brightness == Brightness.dark ? gradientEndDark : gradientEndLight,
  ];

  static List<Color> getGradientSecondary(Brightness brightness) => [
    brightness == Brightness.dark ? gradientSecondaryStartDark : gradientSecondaryStartLight,
    brightness == Brightness.dark ? gradientSecondaryEndDark : gradientSecondaryEndLight,
  ];
}

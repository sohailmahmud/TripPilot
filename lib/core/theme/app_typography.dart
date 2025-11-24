import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// Application Typography System
/// Defines text styles with 6+ typographic levels using Google Fonts
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // ============ DISPLAY STYLES ============
  /// Display Large - Hero text, main headlines
  /// Size: 57sp, Weight: 400, Line height: 1.12
  static TextStyle displayLarge = AppFonts.displayLarge();

  /// Display Medium - Secondary headlines
  /// Size: 45sp, Weight: 400, Line height: 1.16
  static TextStyle displayMedium = AppFonts.displayMedium();

  /// Display Small - Tertiary headlines
  /// Size: 36sp, Weight: 400, Line height: 1.22
  static TextStyle displaySmall = AppFonts.displaySmall();

  // ============ HEADLINE STYLES ============
  /// Headline Large - Main section headers
  /// Size: 32sp, Weight: 600, Line height: 1.25
  static TextStyle headlineLarge = AppFonts.headlineLarge();

  /// Headline Medium - Section subheaders
  /// Size: 28sp, Weight: 600, Line height: 1.29
  static TextStyle headlineMedium = AppFonts.headlineMedium();

  /// Headline Small - Card titles, list headers
  /// Size: 24sp, Weight: 600, Line height: 1.33
  static TextStyle headlineSmall = AppFonts.headlineSmall();

  // ============ TITLE STYLES ============
  /// Title Large - Prominent content headers
  /// Size: 22sp, Weight: 600, Line height: 1.27
  static TextStyle titleLarge = AppFonts.titleLarge();

  /// Title Medium - Item titles, dialog headers
  /// Size: 16sp, Weight: 600, Line height: 1.5
  static TextStyle titleMedium = AppFonts.titleMedium();

  /// Title Small - Secondary titles
  /// Size: 14sp, Weight: 600, Line height: 1.43
  static TextStyle titleSmall = AppFonts.titleSmall();

  // ============ BODY STYLES ============
  /// Body Large - Primary body text
  /// Size: 16sp, Weight: 400, Line height: 1.5
  static TextStyle bodyLarge = AppFonts.bodyLarge();

  /// Body Medium - Secondary body text
  /// Size: 14sp, Weight: 400, Line height: 1.43
  static TextStyle bodyMedium = AppFonts.bodyMedium();

  /// Body Small - Tertiary body text
  /// Size: 12sp, Weight: 400, Line height: 1.33
  static TextStyle bodySmall = AppFonts.bodySmall();

  // ============ LABEL STYLES ============
  /// Label Large - Button text, labels
  /// Size: 14sp, Weight: 600, Line height: 1.43
  static TextStyle labelLarge = AppFonts.labelLarge();

  /// Label Medium - Secondary labels
  /// Size: 12sp, Weight: 600, Line height: 1.33
  static TextStyle labelMedium = AppFonts.labelMedium();

  /// Label Small - Tertiary labels, badges
  /// Size: 11sp, Weight: 600, Line height: 1.45
  static TextStyle labelSmall = AppFonts.labelSmall();

  // ============ CONVENIENCE METHODS ============
  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get text style with custom size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Get text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }
}

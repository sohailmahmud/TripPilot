import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

/// Google Fonts Configuration
/// Defines custom Google Fonts for the app
class AppFonts {
  // Private constructor to prevent instantiation
  AppFonts._();

  // ============ FONT FAMILIES ============
  /// Primary font family - Inter (Clean, modern, readable)
  /// Used for all text including headlines, titles, body, and labels
  static const String primaryFontFamily = 'Inter';

  /// Secondary font family - Poppins (Modern, friendly)
  /// Used for special emphasis and brand elements
  static const String secondaryFontFamily = 'Poppins';

  /// Mono font family - IBM Plex Mono (Code, data)
  /// Used for numbers, technical content
  static const String monoFontFamily = 'IBMPlexMono';

  // ============ DISPLAY STYLES WITH FONTS ============
  /// Display Large with Google Font
  static TextStyle displayLarge() =>
      GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        height: 1.12,
        letterSpacing: 0,
      );

  /// Display Medium with Google Font
  static TextStyle displayMedium() =>
      GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w300,
        height: 1.16,
        letterSpacing: 0,
      );

  /// Display Small with Google Font
  static TextStyle displaySmall() =>
      GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w300,
        height: 1.22,
        letterSpacing: 0,
      );

  // ============ HEADLINE STYLES WITH FONTS ============
  /// Headline Large with Google Font
  static TextStyle headlineLarge() =>
      GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        height: 1.25,
        letterSpacing: 0,
      );

  /// Headline Medium with Google Font
  static TextStyle headlineMedium() =>
      GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.29,
        letterSpacing: 0,
      );

  /// Headline Small with Google Font
  static TextStyle headlineSmall() =>
      GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.33,
        letterSpacing: 0,
      );

  // ============ TITLE STYLES WITH FONTS ============
  /// Title Large with Google Font
  static TextStyle titleLarge() =>
      GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.27,
        letterSpacing: 0,
      );

  /// Title Medium with Google Font
  static TextStyle titleMedium() =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.5,
        letterSpacing: 0.15,
      );

  /// Title Small with Google Font
  static TextStyle titleSmall() =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
      );

  // ============ BODY STYLES WITH FONTS ============
  /// Body Large with Google Font
  static TextStyle bodyLarge() =>
      GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 0.5,
      );

  /// Body Medium with Google Font
  static TextStyle bodyMedium() =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.43,
        letterSpacing: 0.25,
      );

  /// Body Small with Google Font
  static TextStyle bodySmall() =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.33,
        letterSpacing: 0.4,
      );

  // ============ LABEL STYLES WITH FONTS ============
  /// Label Large with Google Font
  static TextStyle labelLarge() =>
      GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.43,
        letterSpacing: 0.1,
      );

  /// Label Medium with Google Font
  static TextStyle labelMedium() =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 1.33,
        letterSpacing: 0.5,
      );

  /// Label Small with Google Font
  static TextStyle labelSmall() =>
      GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        height: 1.45,
        letterSpacing: 0.5,
      );

  // ============ SPECIAL STYLES ============
  /// Monospace font for technical content
  static TextStyle monospace({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w400,
  }) =>
      GoogleFonts.ibmPlexMono(
        fontSize: fontSize,
        fontWeight: fontWeight,
        letterSpacing: 0,
      );

  /// Caption style for small text
  static TextStyle caption() =>
      GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 1.4,
        letterSpacing: 0.4,
      );

  /// Overline style for decorative text
  static TextStyle overline() =>
      GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        height: 1.67,
        letterSpacing: 1.5,
      );

  // ============ CONVENIENCE METHODS ============
  /// Apply color to text style
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Apply size to text style
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Apply weight to text style
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Apply letter spacing to text style
  static TextStyle withLetterSpacing(TextStyle style, double spacing) {
    return style.copyWith(letterSpacing: spacing);
  }

  /// Apply height (line height) to text style
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }
}

import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application Gradient Definitions
/// Premium gradient combinations for professional UI
class AppGradients {
  // Private constructor to prevent instantiation
  AppGradients._();

  // ============ PRIMARY GRADIENTS ============
  /// Primary gradient - Main brand gradient
  /// Used for headers, buttons, featured sections
  static LinearGradient primaryGradientLight = LinearGradient(
    colors: [
      AppColors.primaryLight,
      AppColors.primaryAccentLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient primaryGradientDark = LinearGradient(
    colors: [
      AppColors.primaryAccentDark,
      AppColors.primaryDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ SECONDARY GRADIENTS ============
  /// Secondary gradient - Complementary gradient
  /// Used for alternative sections and accents
  static LinearGradient secondaryGradientLight = LinearGradient(
    colors: [
      AppColors.gradientSecondaryStartLight,
      AppColors.secondaryLight,
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  static LinearGradient secondaryGradientDark = LinearGradient(
    colors: [
      AppColors.secondaryDark,
      AppColors.gradientSecondaryEndDark,
    ],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  // ============ ACCENT GRADIENTS ============
  /// Accent gradient - Teal to cyan gradient
  /// Used for highlights and secondary actions
  static LinearGradient accentGradientLight = LinearGradient(
    colors: [
      AppColors.tertiaryLight,
      AppColors.primaryAccentLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient accentGradientDark = LinearGradient(
    colors: [
      AppColors.primaryAccentDark,
      AppColors.tertiaryDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ SUBTLE GRADIENTS ============
  /// Subtle gradient - Light gradient for backgrounds
  /// Used for card backgrounds and subtle sections
  static LinearGradient subtleGradientLight = LinearGradient(
    colors: [
      AppColors.surfaceLight,
      AppColors.surfaceVariantLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient subtleGradientDark = LinearGradient(
    colors: [
      AppColors.surfaceVariantDark,
      AppColors.surfaceDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ PREMIUM GRADIENTS ============
  /// Premium gradient - Rich multi-color gradient
  /// Used for premium features and hero sections
  static LinearGradient premiumGradientLight = LinearGradient(
    colors: [
      AppColors.primaryLight,
      AppColors.primaryAccentLight,
      AppColors.tertiaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient premiumGradientDark = LinearGradient(
    colors: [
      AppColors.primaryDark,
      AppColors.primaryAccentDark,
      AppColors.tertiaryDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============ DIAGONAL GRADIENTS ============
  /// Diagonal gradient - Diagonal direction for modern look
  /// Used for dynamic sections and featured cards
  static LinearGradient diagonalGradientLight = LinearGradient(
    colors: [
      AppColors.primaryLight,
      AppColors.secondaryLight,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
  );

  static LinearGradient diagonalGradientDark = LinearGradient(
    colors: [
      AppColors.primaryDark,
      AppColors.secondaryDark,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: const [0.0, 1.0],
  );

  // ============ RADIAL GRADIENTS ============
  /// Radial gradient - Circular gradient for special effects
  /// Used for emphasis and decorative elements
  static RadialGradient radialGradientLight = RadialGradient(
    colors: [
      AppColors.primaryLight.withValues(alpha: 0.1),
      AppColors.primaryLight.withValues(alpha: 0.0),
    ],
    radius: 1.5,
  );

  static RadialGradient radialGradientDark = RadialGradient(
    colors: [
      AppColors.primaryDark.withValues(alpha: 0.2),
      AppColors.primaryDark.withValues(alpha: 0.0),
    ],
    radius: 1.5,
  );

  // ============ CONVENIENCE METHODS ============
  /// Get primary gradient based on brightness
  static LinearGradient getPrimaryGradient(Brightness brightness) =>
      brightness == Brightness.dark ? primaryGradientDark : primaryGradientLight;

  /// Get secondary gradient based on brightness
  static LinearGradient getSecondaryGradient(Brightness brightness) =>
      brightness == Brightness.dark ? secondaryGradientDark : secondaryGradientLight;

  /// Get accent gradient based on brightness
  static LinearGradient getAccentGradient(Brightness brightness) =>
      brightness == Brightness.dark ? accentGradientDark : accentGradientLight;

  /// Get subtle gradient based on brightness
  static LinearGradient getSubtleGradient(Brightness brightness) =>
      brightness == Brightness.dark ? subtleGradientDark : subtleGradientLight;

  /// Get premium gradient based on brightness
  static LinearGradient getPremiumGradient(Brightness brightness) =>
      brightness == Brightness.dark ? premiumGradientDark : premiumGradientLight;

  /// Get diagonal gradient based on brightness
  static LinearGradient getDiagonalGradient(Brightness brightness) =>
      brightness == Brightness.dark ? diagonalGradientDark : diagonalGradientLight;

  /// Get radial gradient based on brightness
  static RadialGradient getRadialGradient(Brightness brightness) =>
      brightness == Brightness.dark ? radialGradientDark : radialGradientLight;
}

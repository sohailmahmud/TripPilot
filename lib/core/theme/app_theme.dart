import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_spacing.dart';
import 'app_elevation.dart';

/// Application theme configuration
/// Integrates color system, typography, spacing, and elevation
class AppTheme {
  /// Light theme
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryLight,
        brightness: Brightness.light,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        tertiary: AppColors.tertiaryLight,
        error: AppColors.errorLight,
        surface: AppColors.surfaceLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,
      // ============ TEXT THEME ============
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge(),
        displayMedium: AppFonts.displayMedium(),
        displaySmall: AppFonts.displaySmall(),
        headlineLarge: AppFonts.headlineLarge(),
        headlineMedium: AppFonts.headlineMedium(),
        headlineSmall: AppFonts.headlineSmall(),
        titleLarge: AppFonts.titleLarge(),
        titleMedium: AppFonts.titleMedium(),
        titleSmall: AppFonts.titleSmall(),
        bodyLarge: AppFonts.bodyLarge(),
        bodyMedium: AppFonts.bodyMedium(),
        bodySmall: AppFonts.bodySmall(),
        labelLarge: AppFonts.labelLarge(),
        labelMedium: AppFonts.labelMedium(),
        labelSmall: AppFonts.labelSmall(),
      ),
      // ============ APP BAR THEME ============
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppElevation.level1,
        backgroundColor: AppColors.primaryLight,
        foregroundColor: Colors.white,
        titleTextStyle: AppFonts.titleLarge().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        shadowColor: AppColors.overlayLight,
      ),
      // ============ INPUT DECORATION THEME ============
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryLight,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorLight,
            width: 2,
          ),
        ),
        hintStyle: AppFonts.bodyMedium().copyWith(
          color: AppColors.textTertiaryLight,
        ),
        labelStyle: AppFonts.labelMedium().copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
      // ============ ELEVATED BUTTON THEME ============
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textDisabledLight,
          disabledForegroundColor: Colors.white54,
          padding: AppSpacing.buttonPadding,
          elevation: AppElevation.level2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppFonts.labelLarge().copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // ============ TEXT BUTTON THEME ============
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          padding: AppSpacing.buttonPadding,
          textStyle: AppFonts.labelLarge(),
        ),
      ),
      // ============ OUTLINED BUTTON THEME ============
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(
            color: AppColors.primaryLight,
            width: 1.5,
          ),
          padding: AppSpacing.buttonPadding,
          textStyle: AppFonts.labelLarge().copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      // ============ CARD THEME ============
      cardTheme: CardThemeData(
        color: AppColors.surfaceLight,
        elevation: AppElevation.level1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: AppColors.borderSubtleLight,
            width: 0.5,
          ),
        ),
      ),
      // ============ DIALOG THEME ============
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppElevation.level5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppFonts.headlineSmall().copyWith(
          color: AppColors.textPrimaryLight,
        ),
        contentTextStyle: AppFonts.bodyMedium().copyWith(
          color: AppColors.textSecondaryLight,
        ),
      ),
      // ============ BOTTOM SHEET THEME ============
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceLight,
        elevation: AppElevation.level5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }

  /// Dark theme
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryDark,
        brightness: Brightness.dark,
        primary: AppColors.primaryDark,
        secondary: AppColors.secondaryDark,
        tertiary: AppColors.tertiaryDark,
        error: AppColors.errorDark,
        surface: AppColors.surfaceDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,
      // ============ TEXT THEME ============
      textTheme: TextTheme(
        displayLarge: AppFonts.displayLarge().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: AppFonts.displayMedium().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: AppFonts.displaySmall().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: AppFonts.headlineLarge().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: AppFonts.headlineMedium().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: AppFonts.headlineSmall().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: AppFonts.titleLarge().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: AppFonts.titleMedium().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: AppFonts.titleSmall().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: AppFonts.bodyLarge().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: AppFonts.bodyMedium().copyWith(
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: AppFonts.bodySmall().copyWith(
          color: AppColors.textSecondaryDark,
        ),
        labelLarge: AppFonts.labelLarge().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: AppFonts.labelMedium().copyWith(
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: AppFonts.labelSmall().copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      // ============ APP BAR THEME ============
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: AppElevation.level1,
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        titleTextStyle: AppFonts.titleLarge().copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        shadowColor: AppColors.overlayDark,
      ),
      // ============ INPUT DECORATION THEME ============
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding: AppSpacing.inputPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderDark,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.borderDark,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryDark,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.errorDark,
            width: 2,
          ),
        ),
        hintStyle: AppFonts.bodyMedium().copyWith(
          color: AppColors.textTertiaryDark,
        ),
        labelStyle: AppFonts.labelMedium().copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      // ============ ELEVATED BUTTON THEME ============
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.textDisabledDark,
          disabledForegroundColor: Colors.white30,
          padding: AppSpacing.buttonPadding,
          elevation: AppElevation.level2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: AppFonts.labelLarge().copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      // ============ TEXT BUTTON THEME ============
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          padding: AppSpacing.buttonPadding,
          textStyle: AppFonts.labelLarge(),
        ),
      ),
      // ============ OUTLINED BUTTON THEME ============
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDark,
          side: const BorderSide(
            color: AppColors.primaryDark,
            width: 1.5,
          ),
          padding: AppSpacing.buttonPadding,
          textStyle: AppFonts.labelLarge().copyWith(
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      // ============ CARD THEME ============
      cardTheme: CardThemeData(
        color: AppColors.surfaceDark,
        elevation: AppElevation.level1,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(
            color: AppColors.borderSubtleDark,
            width: 0.5,
          ),
        ),
      ),
      // ============ DIALOG THEME ============
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: AppElevation.level5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        titleTextStyle: AppFonts.headlineSmall().copyWith(
          color: AppColors.textPrimaryDark,
        ),
        contentTextStyle: AppFonts.bodyMedium().copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),
      // ============ BOTTOM SHEET THEME ============
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: AppElevation.level5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

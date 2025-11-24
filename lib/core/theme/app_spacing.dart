import 'package:flutter/material.dart';

/// Spacing System
/// 4dp base grid for consistent spacing throughout the app
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // ============ BASE GRID (4dp) ============
  /// 4dp - Smallest spacing unit
  static const double xs = 4;

  /// 8dp - Extra small spacing
  static const double sm = 8;

  /// 12dp - Small spacing
  static const double md = 12;

  /// 16dp - Standard spacing (most common)
  static const double lg = 16;

  /// 20dp - Large spacing
  static const double xl = 20;

  /// 24dp - Extra large spacing
  static const double xxl = 24;

  /// 32dp - 3XL spacing
  static const double huge = 32;

  /// 40dp - Very huge spacing
  static const double massive = 40;

  // ============ PADDING SHORTCUTS ============
  /// Padding with same value on all sides
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Padding symmetric (horizontal, vertical)
  static EdgeInsets symmetric({
    double horizontal = 0,
    double vertical = 0,
  }) =>
      EdgeInsets.symmetric(
        horizontal: horizontal,
        vertical: vertical,
      );

  /// Padding only on specific sides
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      );

  // ============ COMMON PADDING COMBINATIONS ============
  /// Standard card padding
  static final EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Standard content padding
  static final EdgeInsets contentPadding = EdgeInsets.all(lg);

  /// Button padding
  static final EdgeInsets buttonPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// Text field padding
  static final EdgeInsets inputPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: md);

  /// List item padding
  static final EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: lg, vertical: sm);

  /// Dialog padding
  static final EdgeInsets dialogPadding = EdgeInsets.all(xl);

  /// Bottom sheet padding
  static final EdgeInsets bottomSheetPadding =
      EdgeInsets.fromLTRB(lg, xl, lg, lg);
}

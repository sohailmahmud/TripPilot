import 'package:flutter/material.dart';

/// Responsive Design System
/// Screen breakpoints and responsive utilities for adaptive layouts
class ResponsiveLayout {
  // Private constructor to prevent instantiation
  ResponsiveLayout._();

  // ============ SCREEN BREAKPOINTS ============
  /// Minimum phone width (320dp)
  static const double phoneSmallMin = 320;

  /// Standard phone width (360dp)
  static const double phoneMin = 360;

  /// Large phone width (480dp)
  static const double phoneLargeMin = 480;

  /// Tablet width (600dp)
  static const double tabletMin = 600;

  /// Large tablet width (840dp)
  static const double tabletLargeMin = 840;

  /// Desktop width (1200dp)
  static const double desktopMin = 1200;

  /// Large desktop width (1600dp)
  static const double desktopLargeMin = 1600;

  // ============ DEVICE TYPE DETECTION ============
  /// Check if device is phone (width < 600dp)
  static bool isPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < tabletMin;
  }

  /// Check if device is tablet (width >= 600dp and < 840dp)
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletMin && width < tabletLargeMin;
  }

  /// Check if device is large tablet (width >= 840dp and < 1200dp)
  static bool isLargeTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tabletLargeMin && width < desktopMin;
  }

  /// Check if device is desktop (width >= 1200dp)
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopMin;
  }

  /// Check if device is in landscape mode
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// Check if device is in portrait mode
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // ============ SCREEN DIMENSIONS ============
  /// Get screen width
  static double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get screen height
  static double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Get safe area top padding (status bar height)
  static double safeAreaTop(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get safe area bottom padding (navigation bar height)
  static double safeAreaBottom(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get device pixel ratio (screen density)
  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  // ============ RESPONSIVE SIZING ============
  /// Get responsive width - scales with screen width
  /// Useful for flexible layouts
  static double responsiveWidth(BuildContext context, double maxWidth) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth > maxWidth ? maxWidth : screenWidth;
  }

  /// Get responsive padding based on screen size
  static double responsivePadding(BuildContext context) {
    final width = screenWidth(context);
    if (width < phoneSmallMin) return 8;
    if (width < phoneMin) return 12;
    if (width < phoneLargeMin) return 16;
    if (width < tabletMin) return 20;
    if (width < tabletLargeMin) return 24;
    return 32;
  }

  /// Get responsive font size scaling factor
  static double fontScaleFactor(BuildContext context) {
    return 1.0; // Use textScaler instead for better control
  }

  /// Get responsive grid columns based on screen size
  static int responsiveGridColumns(BuildContext context) {
    final width = screenWidth(context);
    if (width < tabletMin) return 2; // Phone: 2 columns
    if (width < tabletLargeMin) return 3; // Tablet: 3 columns
    return 4; // Large tablet/Desktop: 4 columns
  }

  // ============ BREAKPOINT-SPECIFIC SIZING ============
  /// Get responsive value based on device type
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T phone,
    required T tablet,
    required T largeTablet,
    required T desktop,
  }) {
    final width = screenWidth(context);
    if (width >= desktopMin) return desktop;
    if (width >= tabletLargeMin) return largeTablet;
    if (width >= tabletMin) return tablet;
    return phone;
  }

  /// Get responsive value with default
  static T getResponsiveValueWithDefault<T>({
    required BuildContext context,
    required T defaultValue,
    T? phone,
    T? tablet,
    T? largeTablet,
    T? desktop,
  }) {
    final width = screenWidth(context);
    if (width >= desktopMin && desktop != null) return desktop;
    if (width >= tabletLargeMin && largeTablet != null) return largeTablet;
    if (width >= tabletMin && tablet != null) return tablet;
    if (width < tabletMin && phone != null) return phone;
    return defaultValue;
  }
}

/// Responsive widget extension
extension ResponsiveContext on BuildContext {
  /// Check if device is phone
  bool get isPhone => ResponsiveLayout.isPhone(this);

  /// Check if device is tablet
  bool get isTablet => ResponsiveLayout.isTablet(this);

  /// Check if device is large tablet
  bool get isLargeTablet => ResponsiveLayout.isLargeTablet(this);

  /// Check if device is desktop
  bool get isDesktop => ResponsiveLayout.isDesktop(this);

  /// Check if landscape
  bool get isLandscape => ResponsiveLayout.isLandscape(this);

  /// Check if portrait
  bool get isPortrait => ResponsiveLayout.isPortrait(this);

  /// Get screen width
  double get screenWidth => ResponsiveLayout.screenWidth(this);

  /// Get screen height
  double get screenHeight => ResponsiveLayout.screenHeight(this);

  /// Get responsive padding
  double get responsivePadding =>
      ResponsiveLayout.responsivePadding(this);

  /// Get responsive grid columns
  int get responsiveGridColumns =>
      ResponsiveLayout.responsiveGridColumns(this);
}

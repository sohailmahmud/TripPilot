import 'package:flutter/material.dart';

/// Elevation and Shadow System
/// Defines elevation levels and corresponding shadow effects
class AppElevation {
  // Private constructor to prevent instantiation
  AppElevation._();

  // ============ ELEVATION LEVELS ============
  /// Level 0 - No elevation (flat)
  static const double level0 = 0;

  /// Level 1 - Minimal elevation (1dp)
  static const double level1 = 1;

  /// Level 2 - Low elevation (3dp)
  static const double level2 = 3;

  /// Level 3 - Medium elevation (6dp)
  static const double level3 = 6;

  /// Level 4 - High elevation (8dp)
  static const double level4 = 8;

  /// Level 5 - Very high elevation (12dp)
  static const double level5 = 12;

  // ============ SHADOW DEFINITIONS ============
  /// No shadow - for level 0 elements
  static final List<BoxShadow> shadowNone = [];

  /// Shadow Level 1 - Minimal shadow for subtle depth
  static final List<BoxShadow> shadowLevel1 = [
    BoxShadow(
      color: const Color(0x0A000000),
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  /// Shadow Level 2 - Low shadow for cards
  static final List<BoxShadow> shadowLevel2 = [
    BoxShadow(
      color: const Color(0x0D000000),
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: const Color(0x1F000000),
      blurRadius: 2,
      offset: const Offset(0, 2),
    ),
  ];

  /// Shadow Level 3 - Medium shadow for elevated cards
  static final List<BoxShadow> shadowLevel3 = [
    BoxShadow(
      color: const Color(0x12000000),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: const Color(0x1F000000),
      blurRadius: 4,
      offset: const Offset(0, 4),
    ),
  ];

  /// Shadow Level 4 - High shadow for floating elements
  static final List<BoxShadow> shadowLevel4 = [
    BoxShadow(
      color: const Color(0x14000000),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: const Color(0x3D000000),
      blurRadius: 8,
      offset: const Offset(0, 6),
    ),
  ];

  /// Shadow Level 5 - Very high shadow for modals
  static final List<BoxShadow> shadowLevel5 = [
    BoxShadow(
      color: const Color(0x1A000000),
      blurRadius: 16,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: const Color(0x3D000000),
      blurRadius: 12,
      offset: const Offset(0, 12),
    ),
  ];

  // ============ CONVENIENCE METHODS ============
  /// Get shadow list for elevation level
  static List<BoxShadow> getShadow(int level) {
    switch (level) {
      case 0:
        return shadowNone;
      case 1:
        return shadowLevel1;
      case 2:
        return shadowLevel2;
      case 3:
        return shadowLevel3;
      case 4:
        return shadowLevel4;
      case 5:
        return shadowLevel5;
      default:
        return shadowNone;
    }
  }

  /// Get elevation value for level
  static double getElevation(int level) {
    switch (level) {
      case 0:
        return level0;
      case 1:
        return level1;
      case 2:
        return level2;
      case 3:
        return level3;
      case 4:
        return level4;
      case 5:
        return level5;
      default:
        return level0;
    }
  }
}

/// Elevation extension for easy usage
extension ElevationExtension on int {
  /// Get shadow for this elevation level
  List<BoxShadow> get shadow => AppElevation.getShadow(this);

  /// Get elevation value
  double get elevation => AppElevation.getElevation(this);
}

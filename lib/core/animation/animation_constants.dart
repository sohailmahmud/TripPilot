import 'package:flutter/material.dart';

/// Animation Constants and Durations
/// Standardized timing for consistent animations across the app
class AnimationConstants {
  AnimationConstants._();

  // ============ DURATIONS ============
  /// Ultra-fast animations (micro-interactions)
  static const Duration ultraFast = Duration(milliseconds: 150);

  /// Fast animations (quick feedback)
  static const Duration fast = Duration(milliseconds: 250);

  /// Standard animations (normal transitions)
  static const Duration standard = Duration(milliseconds: 300);

  /// Slow animations (emphasis, important transitions)
  static const Duration slow = Duration(milliseconds: 400);

  /// Very slow animations (long transitions, hero animations)
  static const Duration verySlow = Duration(milliseconds: 600);

  /// Extended duration (page transitions)
  static const Duration extended = Duration(milliseconds: 800);

  // ============ STAGGER DELAYS ============
  /// Delay between staggered items (small)
  static const Duration staggerDelaySmall = Duration(milliseconds: 50);

  /// Delay between staggered items (medium)
  static const Duration staggerDelayMedium = Duration(milliseconds: 75);

  /// Delay between staggered items (large)
  static const Duration staggerDelayLarge = Duration(milliseconds: 100);

  // ============ CURVES ============
  /// Standard easing curve
  static const Curve standardCurve = Curves.easeInOut;

  /// Emphasis curve (more pronounced)
  static const Curve emphasisCurve = Curves.easeOut;

  /// Bounce curve (playful)
  static const Curve bounceCurve = Curves.elasticOut;

  /// Fast curve (quick)
  static const Curve fastCurve = Curves.fastOutSlowIn;

  /// Linear curve (constant speed)
  static const Curve linearCurve = Curves.linear;

  // ============ OFFSET CALCULATIONS ============
  /// Calculate stagger delay for list item
  static Duration getStaggerDelay(
    int index, {
    Duration delay = staggerDelayMedium,
  }) {
    return delay * index;
  }

  /// Calculate stagger delay for grid item
  static Duration getGridStaggerDelay(
    int index,
    int crossAxisCount, {
    Duration delay = staggerDelayMedium,
  }) {
    return delay * (index ~/ crossAxisCount);
  }
}

/// Stagger Animation Configuration
class StaggerConfig {
  /// Duration of each animation
  final Duration duration;

  /// Delay before animation starts
  final Duration delay;

  /// Animation curve
  final Curve curve;

  /// Whether to reverse animation
  final bool reverse;

  /// Stagger type
  final StaggerType staggerType;

  const StaggerConfig({
    this.duration = AnimationConstants.standard,
    this.delay = Duration.zero,
    this.curve = AnimationConstants.standardCurve,
    this.reverse = false,
    this.staggerType = StaggerType.sequential,
  });

  /// Copy with modified properties
  StaggerConfig copyWith({
    Duration? duration,
    Duration? delay,
    Curve? curve,
    bool? reverse,
    StaggerType? staggerType,
  }) {
    return StaggerConfig(
      duration: duration ?? this.duration,
      delay: delay ?? this.delay,
      curve: curve ?? this.curve,
      reverse: reverse ?? this.reverse,
      staggerType: staggerType ?? this.staggerType,
    );
  }
}

/// Types of stagger animations
enum StaggerType {
  /// Items animate one after another
  sequential,

  /// Items animate with a small overlap
  staggered,

  /// All items animate together with different start times
  grouped,

  /// Items animate in a wave pattern
  wave,

  /// Items animate from outside to inside
  spiral,
}

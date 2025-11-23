import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Advanced Animation Helpers
/// Reusable animation utilities for common patterns
class AnimationHelpers {
  AnimationHelpers._();

  // ============ FADE IN ANIMATIONS ============
  /// Simple fade in animation
  static Animation<double> fadeInAnimation(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeIn),
    );
  }

  /// Fade in then out animation
  static Animation<double> fadeInOutAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
    ]).animate(controller);
  }

  // ============ SCALE ANIMATIONS ============
  /// Bounce scale animation
  static Animation<double> bounceScaleAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.8, end: 1.1)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 100,
      ),
    ]).animate(controller);
  }

  /// Pulse scale animation
  static Animation<double> pulseScaleAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.1, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(controller);
  }

  // ============ SLIDE ANIMATIONS ============
  /// Slide from left animation
  static Animation<Offset> slideFromLeftAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(-1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  /// Slide from right animation
  static Animation<Offset> slideFromRightAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  /// Slide from top animation
  static Animation<Offset> slideFromTopAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  /// Slide from bottom animation
  static Animation<Offset> slideFromBottomAnimation(
    AnimationController controller,
  ) {
    return Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOut),
    );
  }

  // ============ ROTATION ANIMATIONS ============
  /// 360 degree rotation animation
  static Animation<double> rotationAnimation(AnimationController controller) {
    return Tween<double>(begin: 0, end: 6.28).animate(
      CurvedAnimation(parent: controller, curve: Curves.linear),
    );
  }

  /// Bounce rotation animation
  static Animation<double> bounceRotationAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 0, end: 0.5).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  // ============ ELASTIC ANIMATIONS ============
  /// Elastic entrance animation
  static Animation<double> elasticEntranceAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );
  }

  /// Elastic exit animation
  static Animation<double> elasticExitAnimation(
    AnimationController controller,
  ) {
    return Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticIn),
    );
  }

  // ============ COLOR ANIMATIONS ============
  /// Color transition animation
  static Animation<Color?> colorAnimation(
    AnimationController controller,
    Color begin,
    Color end,
  ) {
    return ColorTween(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  // ============ SIZE ANIMATIONS ============
  /// Width animation
  static Animation<double> widthAnimation(
    AnimationController controller,
    double begin,
    double end,
  ) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  /// Height animation
  static Animation<double> heightAnimation(
    AnimationController controller,
    double begin,
    double end,
  ) {
    return Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  // ============ COMPLEX ANIMATIONS ============
  /// Flip animation (rotation around Y axis simulation)
  static Animation<double> flipAnimation(AnimationController controller) {
    return Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    );
  }

  /// Shake animation
  static Animation<double> shakeAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -10), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -10, end: 10), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 10, end: -10), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: -10, end: 10), weight: 10),
      TweenSequenceItem(tween: Tween<double>(begin: 10, end: 0), weight: 60),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  /// Wiggle animation (subtle side-to-side)
  static Animation<double> wiggleAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -5), weight: 25),
      TweenSequenceItem(tween: Tween<double>(begin: -5, end: 5), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 5, end: 0), weight: 25),
    ]).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  /// Heartbeat animation (scale pulse)
  static Animation<double> heartbeatAnimation(AnimationController controller) {
    return TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.2)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 1.15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 25,
      ),
    ]).animate(controller);
  }
}

/// Page Transition Animations
class PageTransitionAnimations {
  PageTransitionAnimations._();

  /// Fade transition page route
  static Route<T> fadeTransition<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  /// Slide transition page route
  static Route<T> slideTransition<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
    Offset begin = const Offset(1, 0),
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(Tween<Offset>(begin: begin, end: Offset.zero)),
          child: child,
        );
      },
    );
  }

  /// Scale transition page route
  static Route<T> scaleTransition<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(scale: animation, child: child);
      },
    );
  }

  /// Rotation transition page route
  static Route<T> rotationTransition<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(turns: animation, child: child);
      },
    );
  }

  /// Shared axis transition (X-axis)
  static Route<T> sharedAxisTransitionX<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  /// Shared axis transition (Y-axis)
  static Route<T> sharedAxisTransitionY<T>(
    Widget page, {
    Duration duration = AnimationConstants.standard,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

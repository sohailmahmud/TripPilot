import 'package:flutter/material.dart';
import 'animation_constants.dart';

/// Staggered Animation Builder
/// Provides common stagger animation patterns
class StaggeredAnimationBuilder extends StatefulWidget {
  /// Child widget to animate
  final Widget child;

  /// Animation duration
  final Duration duration;

  /// Initial delay before animation
  final Duration delay;

  /// Animation curve
  final Curve curve;

  /// Index for stagger calculation
  final int index;

  /// Stagger type
  final StaggerType staggerType;

  /// Offset animation (position)
  final Offset offsetBegin;
  final Offset offsetEnd;

  /// Opacity animation
  final double opacityBegin;
  final double opacityEnd;

  /// Scale animation
  final double scaleBegin;
  final double scaleEnd;

  /// Rotation animation (in radians)
  final double? rotationBegin;
  final double? rotationEnd;

  const StaggeredAnimationBuilder({
    super.key,
    required this.child,
    this.duration = AnimationConstants.standard,
    this.delay = Duration.zero,
    this.curve = AnimationConstants.standardCurve,
    this.index = 0,
    this.staggerType = StaggerType.staggered,
    this.offsetBegin = const Offset(0, 20),
    this.offsetEnd = Offset.zero,
    this.opacityBegin = 0,
    this.opacityEnd = 1,
    this.scaleBegin = 0.95,
    this.scaleEnd = 1,
    this.rotationBegin,
    this.rotationEnd,
  });

  @override
  State<StaggeredAnimationBuilder> createState() =>
      _StaggeredAnimationBuilderState();
}

class _StaggeredAnimationBuilderState extends State<StaggeredAnimationBuilder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  Animation<double>? _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Calculate total duration including delay
    final totalDuration =
        widget.duration + _calculateDelay(widget.index, widget.staggerType);
    final animationDelay =
        widget.delay + _calculateDelay(widget.index, widget.staggerType);

    _controller = AnimationController(
      duration: totalDuration,
      vsync: this,
    );

    // Main animation curve
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          (animationDelay.inMilliseconds / totalDuration.inMilliseconds)
              .clamp(0.0, 1.0),
          1.0,
          curve: widget.curve,
        ),
      ),
    );

    // Offset animation
    _offsetAnimation = Tween<Offset>(
      begin: widget.offsetBegin,
      end: widget.offsetEnd,
    ).animate(_animation);

    // Opacity animation
    _opacityAnimation = Tween<double>(
      begin: widget.opacityBegin,
      end: widget.opacityEnd,
    ).animate(_animation);

    // Scale animation
    _scaleAnimation = Tween<double>(
      begin: widget.scaleBegin,
      end: widget.scaleEnd,
    ).animate(_animation);

    // Rotation animation (if provided)
    if (widget.rotationBegin != null && widget.rotationEnd != null) {
      _rotationAnimation = Tween<double>(
        begin: widget.rotationBegin!,
        end: widget.rotationEnd!,
      ).animate(_animation);
    }

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calculate stagger delay based on type
  Duration _calculateDelay(int index, StaggerType type) {
    switch (type) {
      case StaggerType.sequential:
        return AnimationConstants.getStaggerDelay(
          index,
          delay: AnimationConstants.staggerDelayMedium,
        );
      case StaggerType.staggered:
        return AnimationConstants.getStaggerDelay(
          index,
          delay: AnimationConstants.staggerDelaySmall,
        );
      case StaggerType.grouped:
        return Duration(milliseconds: (index ~/ 3) * 100);
      case StaggerType.wave:
        return Duration(milliseconds: (index % 4) * 75);
      case StaggerType.spiral:
        return Duration(milliseconds: index * 50);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: _rotationAnimation != null
                  ? Transform.rotate(
                      angle: _rotationAnimation!.value,
                      child: widget.child,
                    )
                  : widget.child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Staggered List Animation
/// Animates list items with stagger effect
class StaggeredListView extends StatelessWidget {
  /// List of items to display
  final List<Widget> children;

  /// Stagger configuration
  final StaggerConfig config;

  /// Scroll direction
  final Axis scrollDirection;

  /// Whether list is scrollable
  final bool shrinkWrap;

  /// Physics for scrolling
  final ScrollPhysics? physics;

  /// Padding around the list
  final EdgeInsetsGeometry? padding;

  const StaggeredListView({
    super.key,
    required this.children,
    this.config = const StaggerConfig(),
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return StaggeredAnimationBuilder(
          index: index,
          duration: config.duration,
          delay: config.delay,
          curve: config.curve,
          staggerType: config.staggerType,
          child: children[index],
        );
      },
    );
  }
}

/// Staggered Grid Animation
/// Animates grid items with stagger effect
class StaggeredGridView extends StatelessWidget {
  /// List of items to display
  final List<Widget> children;

  /// Number of columns in grid
  final int crossAxisCount;

  /// Stagger configuration
  final StaggerConfig config;

  /// Main axis spacing
  final double mainAxisSpacing;

  /// Cross axis spacing
  final double crossAxisSpacing;

  /// Child aspect ratio
  final double childAspectRatio;

  /// Padding around the grid
  final EdgeInsetsGeometry? padding;

  /// Physics for scrolling
  final ScrollPhysics? physics;

  const StaggeredGridView({
    super.key,
    required this.children,
    this.crossAxisCount = 2,
    this.config = const StaggerConfig(),
    this.mainAxisSpacing = 8.0,
    this.crossAxisSpacing = 8.0,
    this.childAspectRatio = 1.0,
    this.padding,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: childAspectRatio,
      ),
      physics: physics,
      padding: padding,
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return StaggeredAnimationBuilder(
          index: index,
          duration: config.duration,
          delay: config.delay,
          curve: config.curve,
          staggerType: config.staggerType,
          child: children[index],
        );
      },
    );
  }
}

/// Staggered Container Animation
/// Animates a single container with stagger effect
class StaggeredContainer extends StatelessWidget {
  /// Child widget
  final Widget child;

  /// Animation configuration
  final StaggerConfig config;

  /// Index for stagger calculation
  final int index;

  const StaggeredContainer({
    super.key,
    required this.child,
    this.config = const StaggerConfig(),
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredAnimationBuilder(
      index: index,
      duration: config.duration,
      delay: config.delay,
      curve: config.curve,
      staggerType: config.staggerType,
      child: child,
    );
  }
}

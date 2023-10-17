import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// {@template cleverList.defaultTransition}
/// A widget providing a default transition for `CleverList` widgets.
///
/// This transition smoothly fades in the child while scaling it up.
/// {@endtemplate}
class DefaultListTransitionBuilder extends StatelessWidget {
  /// {@macro cleverList.defaultTransition}
  const DefaultListTransitionBuilder({
    required this.child,
    required this.animation,
    this.curve = const Cubic(0.2, 0, 0, 1),
    super.key,
  });

  /// The child of this widget.
  final Widget child;

  /// Animation for this transition.
  final Animation<double> animation;

  /// The curve for this transition.
  ///
  /// Uses `Cubic(0.2, 0, 0, 1)` by default.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (animation == kAlwaysCompleteAnimation) {
      return child;
    }

    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.4, 1, curve: Curves.easeOut),
    );

    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 0.6, curve: Curves.easeOut),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedBuilder(
        animation: sizeAnimation,
        builder: (_, child) => ClipRect(
          child: Align(
            heightFactor: sizeAnimation.value,
            widthFactor: sizeAnimation.value,
            child: child,
          ),
        ),
        child: child,
      ),
    );
  }
}

class DefaultListMoveTransitionBuilder extends StatelessWidget {
  /// {@macro cleverList.defaultTransition}
  const DefaultListMoveTransitionBuilder({
    required this.child,
    required this.animation,
    this.curve = const Cubic(0.2, 0, 0, 1),
    super.key,
  });

  /// The child of this widget.
  final Widget child;

  /// Animation for this transition.
  final Animation<double> animation;

  /// The curve for this transition.
  ///
  /// Uses `Cubic(0.2, 0, 0, 1)` by default.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (animation == kAlwaysCompleteAnimation) {
      return child;
    }

    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(1, 1, curve: Curves.easeOut),
    );

    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: curve,
      reverseCurve: curve.flipped,
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedBuilder(
        animation: sizeAnimation,
        builder: (_, child) => ClipRect(
          child: Align(
            heightFactor: sizeAnimation.value,
            widthFactor: sizeAnimation.value,
            child: child,
          ),
        ),
        child: child,
      ),
    );
  }
}

class DefaultListMoveItemTransitionBuilder extends StatelessWidget {
  /// {@macro cleverList.defaultTransition}
  const DefaultListMoveItemTransitionBuilder({
    required this.child,
    required this.animation,
    required this.offset,
    this.curve = const Cubic(0.2, 0, 0, 1),
    super.key,
  });

  /// The child of this widget.
  final Widget child;

  /// Animation for this transition.
  final Animation<double> animation;

  /// The curve for this transition.
  ///
  /// Uses `Cubic(0.2, 0, 0, 1)` by default.
  final Curve curve;

  final Offset offset;

  @override
  Widget build(BuildContext context) {
    if (animation == kAlwaysCompleteAnimation) {
      return child;
    }

    final slideAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final offsetTween = Tween<Offset>(begin: offset, end: Offset.zero);

    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: const Interval(0, 1, curve: Curves.easeOut),
    );
    return SlideTransition(
      position: offsetTween.animate(slideAnimation),
      child: child,
    );
  }
}

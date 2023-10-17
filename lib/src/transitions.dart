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
    this.curve = Curves.easeOut,
    super.key,
  });

  /// The child of this widget.
  final Widget child;

  /// Animation for this transition.
  final Animation<double> animation;

  /// The curve for this transition.
  ///
  /// Uses Curves.easeOut by default.
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    if (animation == kAlwaysCompleteAnimation) {
      return child;
    }

    final fadeAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(0.4, 1, curve: curve),
    );

    final sizeAnimation = CurvedAnimation(
      parent: animation,
      curve: Interval(0, 0.6, curve: curve),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: AnimatedBuilder(
        animation: sizeAnimation,
        builder: (_, child) {
          return ClipRect(
            child: Align(
              heightFactor: sizeAnimation.value,
              widthFactor: sizeAnimation.value,
              child: child,
            ),
          );
        },
        child: child,
      ),
    );
  }
}

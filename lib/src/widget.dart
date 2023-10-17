import 'package:clever_list/clever_list.dart';
import 'package:flutter/widgets.dart';

/// A builder for a transition animation when an item
/// in a [CleverListBaseState] changes.
typedef CleverListTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// {@template cleverListWidget}
/// An abstract implementation of an animated List widget that animates
/// changes to the list automatically.
///
/// {@template cleverList.usage}
/// To use this widget, provide a list of items and a builder function that
/// generates the widget for each item. You can also specify optional transition
/// builders for insertions and removals and custom animation durations.
/// {@endtemplate}
/// {@endtemplate}
abstract class CleverListWidget<T> extends CleverListBase<T> {
  /// {@macro cleverListWidget}
  const CleverListWidget({
    required super.items,
    required this.builder,
    super.equalityChecker,
    super.itemIdEquality,
    super.detectMoves,
    super.key,
    this.insertDuration = const Duration(milliseconds: 400),
    this.insertTransitionBuilder,
    this.removeDuration = const Duration(milliseconds: 300),
    this.removeTransitionBuilder,
  });

  /// A builder function that generates a widget for each item in the list.
  final Widget Function(BuildContext context, T value) builder;

  /// {@template cleverList.insertTransitionBuilder}
  /// A custom transition builder for insert animations.
  ///
  /// The `child` is obtained by the [builder].
  ///
  /// When this is `null` the list uses [DefaultListTransitionBuilder].
  /// {@endtemplate}
  final CleverListTransitionBuilder? insertTransitionBuilder;

  /// A custom transition builder for remove animations.
  final CleverListTransitionBuilder? removeTransitionBuilder;

  /// The duration of insert animations.
  final Duration insertDuration;

  /// The duration of remove animations.
  final Duration removeDuration;
}

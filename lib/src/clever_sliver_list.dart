import 'package:clever_list/src/base.dart';
import 'package:clever_list/src/transitions.dart';
import 'package:clever_list/src/widget.dart';
import 'package:flutter/material.dart';

/// A scrollable, animated list widget that efficiently manages a dynamic list
/// of [items] within a [CustomScrollView] using slivers. Inserts and removals
/// into the list are automatically animated.
///
/// {@macro cleverList.equality}
///
/// {@macro cleverList.usage}
///
/// {@template cleverList.sliver.example}
/// Example:
/// ```dart
/// final items = ['item 1','item 2','item 3'];
///
/// CleverSliverList<String>(
///   items: items,
///   builder: (context, value) {
///     return ListTile(
///       title: Text(value),
///     );
///   },
///   insertTransitionBuilder: (context, animation, child) {
///     return SlideTransition(
///       position: Tween<Offset>(
///         begin: const Offset(1.0, 0.0),
///         end: Offset.zero,
///       ).animate(animation),
///       child: child,
///     );
///   },
///   removeTransitionBuilder: (context, animation, child) {
///     return FadeTransition(
///       opacity: animation,
///       child: child,
///     );
///   },
///   insertDuration: const Duration(milliseconds: 500),
///   removeDuration: const Duration(milliseconds: 300),
/// )
/// ```
/// {@endtemplate}
class CleverSliverList<T> extends CleverListWidget<T> {
  /// Creates a [CleverSliverList] widget.
  ///
  /// The [items] parameter is required and represents the list of items to
  /// display. The [builder] parameter is a required callback function that
  /// defines how to build a widget for each item.
  ///
  /// {@macro cleverList.equality}
  ///
  /// {@macro cleverList.sliver.example}
  const CleverSliverList({
    required super.items,
    required super.builder,
    super.insertTransitionBuilder,
    super.removeTransitionBuilder,
    super.insertDuration = const Duration(milliseconds: 400),
    super.removeDuration = const Duration(milliseconds: 300),
    super.equalityChecker,
    super.itemIdEquality,
    super.key,
    this.findChildIndexCallback,
  });

  /// A callback to find the index of a child widget based on its key.
  final int? Function(Key)? findChildIndexCallback;

  @override
  CleverListBaseState<T, CleverSliverList<T>> createState() =>
      _CleverSliverListState<T>();
}

class _CleverSliverListState<T>
    extends CleverListBaseState<T, CleverSliverList<T>> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  SliverAnimatedListState get _animatedList => _listKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: widget.items.length,
      findChildIndexCallback: widget.findChildIndexCallback,
      itemBuilder: (context, index, animation) {
        return _insertTransition(
          animation: animation,
          child: widget.builder(context, items[index]),
        );
      },
    );
  }

  Widget _insertTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    if (widget.insertTransitionBuilder != null) {
      return widget.insertTransitionBuilder!(context, animation, child);
    }
    return DefaultListTransitionBuilder(
      animation: animation,
      child: child,
    );
  }

  Widget _removeTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    if (widget.removeTransitionBuilder != null) {
      return widget.removeTransitionBuilder!(context, animation, child);
    }
    return DefaultListTransitionBuilder(
      animation: animation,
      child: child,
    );
  }

  @override
  void insert(int position, int count) {
    for (var i = 0; i < count; i++) {
      _animatedList.insertItem(position, duration: widget.insertDuration);
    }
  }

  @override
  void remove(int position, int count) {
    for (var i = 0; i < count; i++) {
      _animatedList.removeItem(
        position,
        (context, animation) {
          return _removeTransition(
            animation: animation,
            child: widget.builder(context, oldItems[position + i]),
          );
        },
        duration: widget.removeDuration,
      );
    }
  }

  @override
  void change(int position, Object? payload) {
    // The state of the list changed which means
    // that all items are already updated. So nothing to do here.
  }

  @override
  void move(int from, int to) {}
}

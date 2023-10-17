// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: cascade_invocations

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import 'package:clever_list/clever_list.dart';
import 'package:clever_list/src/widget.dart';

/// A scrollable, animated list widget that efficiently manages a dynamic list
/// of items. Inserts and removals into the list are automatically animated.
///
/// {@macro MovableCleverList.equality}
///
/// {@macro MovableCleverList.usage}
///
/// /// Example:
///
/// ```dart
/// final items = ['item 1','item 2','item 3'];
///
/// MovableCleverList<String>(
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
class MovableCleverList<T> extends CleverListWidget<T> {
  /// Creates a [MovableCleverList] widget.
  ///
  /// The [items] parameter is required and represents the list of items to
  /// display. The [builder] parameter is a required callback function that
  /// defines how to build a widget for each item.
  ///
  /// {@macro MovableCleverList.equality}
  ///
  /// {@macro MovableCleverList.sliver.example}
  const MovableCleverList({
    required super.items,
    required super.builder,
    super.insertTransitionBuilder,
    super.removeTransitionBuilder,
    super.insertDuration,
    super.removeDuration,
    super.equalityChecker,
    super.itemIdEquality,
    super.key,
    this.clipBehavior = Clip.hardEdge,
    this.controller,
    this.padding,
    this.physics,
    this.primary,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = false,
  });

  @override
  bool get detectMoves => true;

  /// {@macro flutter.widgets.scroll_view.scrollDirection}
  final Axis scrollDirection;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right and
  /// [scrollDirection] is [Axis.horizontal], then the scroll view scrolls from
  /// left to right when [reverse] is false and from right to left when
  /// [reverse] is true.
  ///
  /// Similarly, if [scrollDirection] is [Axis.vertical], then the scroll view
  /// scrolls from top to bottom when [reverse] is false and from bottom to top
  /// when [reverse] is true.
  ///
  /// Defaults to false.
  final bool reverse;

  /// An object that can be used to control the position to which this scroll
  /// view is scrolled.
  ///
  /// Must be null if [primary] is true.
  ///
  /// A [ScrollController] serves several purposes. It can be used to control
  /// the initial scroll position (see [ScrollController.initialScrollOffset]).
  /// It can be used to control whether the scroll view should automatically
  /// save and restore its scroll position in the [PageStorage] (see
  /// [ScrollController.keepScrollOffset]). It can be used to read the current
  /// scroll position (see [ScrollController.offset]), or change it (see
  /// [ScrollController.animateTo]).
  final ScrollController? controller;

  /// Whether this is the primary scroll view associated with the parent
  /// [PrimaryScrollController].
  ///
  /// On iOS, this identifies the scroll view that will scroll to top in
  /// response to a tap in the status bar.
  ///
  /// Defaults to true when [scrollDirection] is [Axis.vertical] and
  /// [controller] is null.
  final bool? primary;

  /// How the scroll view should respond to user input.
  ///
  /// For example, this determines how the scroll view continues to animate
  /// after the user stops dragging the scroll view.

  /// Defaults to matching platform conventions.
  final ScrollPhysics? physics;

  /// Whether the extent of the scroll view in the [scrollDirection] should be
  /// determined by the contents being viewed.
  ///
  /// If the scroll view does not shrink wrap, then the scroll view will expand
  /// to the maximum allowed size in the [scrollDirection]. If the scroll view
  /// has unbounded constraints in the [scrollDirection], then [shrinkWrap] must
  /// be true.
  ///
  /// Shrink wrapping the content of the scroll view is significantly more
  /// expensive than expanding to the maximum allowed size because the content
  /// can expand and contract during scrolling, which means the size of the
  /// scroll view needs to be recomputed whenever the scroll position changes.
  ///
  /// Defaults to false.
  final bool shrinkWrap;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  final Clip clipBehavior;

  @override
  CleverListBaseState<T, MovableCleverList<T>> createState() =>
      _MovableCleverListState<T>();
}

class _MovableCleverListState<T>
    extends CleverListBaseState<T, MovableCleverList<T>> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  AnimatedListState get _animatedList => _listKey.currentState!;

  final _itemBoxes = <T, _ItemBox>{};

  void registerBox(RenderBox renderBox, T value) {
    _itemBoxes[value] = _ItemBox(
      position: renderBox.localToGlobal(Offset.zero),
      size: renderBox.size,
    );
  }

  void clearBoxes() {
    _itemBoxes.clear();
  }

  @override
  Widget build(BuildContext context) {
    clearBoxes();

    return AnimatedList(
      key: _listKey,
      clipBehavior: widget.clipBehavior,
      controller: widget.controller,
      padding: widget.padding,
      physics: widget.physics,
      primary: widget.primary,
      reverse: widget.reverse,
      shrinkWrap: widget.shrinkWrap,
      scrollDirection: widget.scrollDirection,
      initialItemCount: widget.items.length,
      itemBuilder: (context, index, animation) {
        return _insertTransition(
          animation: animation,
          child: Builder(
            builder: (context) {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                final box = context.findRenderObject()! as RenderBox;
                registerBox(box, items[index]);
              });
              return KeyedSubtree(
                child: widget.builder(
                  context,
                  items[index],
                ),
              );
            },
          ),
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
    return DefaultListMoveTransitionBuilder(
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
    return DefaultListMoveTransitionBuilder(
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
  void move(int from, int to) {
    print('From $from');
    print('To $to');
    _animatedList.removeItem(
      from,
      (context, animation) {
        return _removeTransition(
          animation: animation,
          child: widget.builder(context, oldItems[from]),
        );
      },
      duration: const Duration(milliseconds: 400),
    );

    _animatedList.insertItem(
      to,
      duration: const Duration(milliseconds: 400),
    );

    final fromBox = _itemBoxes[from];
    final toBox = _itemBoxes[to];

    assert(fromBox != null);
    assert(toBox != null);

    late final OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        return _ItemShuttle(
          fromSize: fromBox!.size,
          toSize: toBox!.size,
          startingOffset: fromBox.position,
          endOffset: toBox.position,
          capturedThemes: InheritedTheme.capture(
            from: context,
            to: Overlay.of(context).context,
          ),
          removeOverlay: () {
            entry.remove();
          },
          child: widget.builder(context, items[to]),
        );
      },
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(entry);
    });
  }
}

@immutable
class _ItemBox {
  const _ItemBox({
    required this.position,
    required this.size,
  });
  final Offset position;
  final Size size;
}

class _ItemShuttle extends StatefulWidget {
  const _ItemShuttle({
    required this.fromSize,
    required this.toSize,
    required this.startingOffset,
    required this.endOffset,
    required this.removeOverlay,
    required this.capturedThemes,
    required this.child,
    super.key,
  });

  final Size fromSize;
  final Size toSize;
  final Offset startingOffset;
  final Offset endOffset;
  final Widget child;
  final VoidCallback removeOverlay;
  final CapturedThemes capturedThemes;

  @override
  State<_ItemShuttle> createState() => _ItemShuttleState();
}

class _ItemShuttleState extends State<_ItemShuttle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status != AnimationStatus.forward) {
        widget.removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMovingForward = widget.startingOffset.dy - widget.endOffset.dy > 0;

    final effectiveOffset = Tween<Offset>(
      begin: widget.startingOffset + Offset(0, widget.fromSize.height),
      end: widget.endOffset +
          Offset(0, isMovingForward ? widget.toSize.height : 0),
    );

    final animation = effectiveOffset
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    return widget.capturedThemes.wrap(
      MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Builder(
          builder: (context) {
            return Stack(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Positioned(
                      top: animation.value.dy,
                      left: animation.value.dx,
                      child: child!,
                    );
                  },
                  child: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: widget.fromSize.height,
                      width: widget.fromSize.width,
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

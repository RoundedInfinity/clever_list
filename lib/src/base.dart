import 'package:diffutil_dart/diffutil.dart';
import 'package:flutter/widgets.dart';

/// Checks the equality between [a] and [b].
///
/// Example usage:
/// ```dart
/// (a,b) => a.id == b.id
/// ```
typedef EqualityChecker<T> = bool Function(T a, T b);

/// A low-level implementation for reacting to diff results in a Widget
///
/// {@template cleverList.equality}
/// By default this list uses the [==] operator to check for equality of its
/// [items]. You can override this by implementing a custom [equalityChecker].
///
/// For complex items that have a constant unique identifier, but still have
/// other values that can change use [itemIdEquality] to check for the
/// identifier and [equalityChecker] for changes in its other values.
/// {@endtemplate}
///
/// The corresponding [CleverListBaseState] extends insert, remove, move and
/// change callbacks to react to changes in [items].
abstract class CleverListBase<T> extends StatefulWidget {
  /// Creates a [CleverListBase].
  const CleverListBase({
    required this.items,
    this.equalityChecker,
    this.itemIdEquality,
    this.detectMoves = false,
    super.key,
  });

  /// A list of items in this list.
  ///
  /// These items should be comparable. You can override the
  /// default equality with [equalityChecker].
  final List<T> items;

  /// Defines how the items equality is evaluated.
  final EqualityChecker<T>? equalityChecker;

  /// Checks for a unique identifier.
  ///
  /// This is used to track items that can change some values
  /// but should still be identifiable.
  final EqualityChecker<T>? itemIdEquality;

  /// Wether moves in the list are recognized.
  final bool detectMoves;

  @override
  CleverListBaseState<T, CleverListBase<T>> createState();
}

/// An abstract [State] of [CleverListBase].
///
/// [insert], [remove], [move] and [change] are used to react to changes
/// in [items].
abstract class CleverListBaseState<T, S extends CleverListBase<T>>
    extends State<S> {
  List<T> _newList = [];
  List<T> _oldList = [];

  /// A list of items that are currently in the list.
  List<T> get items => _newList;

  /// A list of items that have been in the list before it was updated.
  List<T> get oldItems => _oldList;

  @override
  void initState() {
    super.initState();

    _newList = widget.items;
  }

  @override
  void didUpdateWidget(covariant S oldWidget) {
    super.didUpdateWidget(oldWidget);

    late final Iterable<DiffUpdate> diff;

    _newList = widget.items;
    _oldList = oldWidget.items;

    if (widget.itemIdEquality == null) {
      // Does not include list changes.
      diff = _defaultDiff(_oldList, _newList);
    } else {
      // Diff that does contain changes.
      diff = _dataObjectDiff(_oldList, _newList);
    }

    for (final update in diff) {
      update.when(
        insert: insert,
        remove: remove,
        move: move,
        change: change,
      );
    }
  }

  Iterable<DiffUpdate> _defaultDiff(List<T> oldList, List<T> newList) {
    return calculateListDiff<T>(
      oldList,
      newList,
      equalityChecker: widget.equalityChecker,
      detectMoves: widget.detectMoves,
    ).getUpdates();
  }

  Iterable<DiffUpdate> _dataObjectDiff(List<T> oldList, List<T> newList) {
    final itemEquality = widget.itemIdEquality!;

    return calculateDiff<T>(
      DataObjectListDiff(
        oldList: oldList,
        newList: newList,
        itemEquality: itemEquality,
        contentEquality: widget.equalityChecker,
      ),
      detectMoves: widget.detectMoves,
    ).getUpdates();
  }

  /// Called when [count] amount of items were inserted into the list
  /// at [position].
  @protected
  void insert(int position, int count);

  /// Called when [count] amount of items were removed from the list
  /// at [position].
  @protected
  void remove(int position, int count);

  /// Called when an item moves from position [from] to [to].
  @protected
  void move(int from, int to);

  /// Called when the item at [position] changed.
  @protected
  void change(int position, Object? payload);
}

/// {@template cleverList.dataObjectDiff}
/// Class that compares two lists of data object.
///
/// [contentEquality] checks if the contents of the object are the same.
///
/// [itemEquality] checks if the items are the same
///  (typically by checking for an unique id).
/// {@endtemplate}
class DataObjectListDiff<T> extends ListDiffDelegate<T> {
  /// {@macro cleverList.dataObjectDiff}
  DataObjectListDiff({
    required List<T> oldList,
    required List<T> newList,
    required this.itemEquality,
    this.contentEquality,
  }) : super(oldList, newList, contentEquality);

  /// Checks if the items are the same
  /// (typically by checking for an unique id).
  final EqualityChecker<T> itemEquality;

  /// checks if the contents of the object are the same.
  final EqualityChecker<T>? contentEquality;

  @override
  bool areContentsTheSame(int oldItemPosition, int newItemPosition) {
    return equalityChecker(oldList[oldItemPosition], newList[newItemPosition]);
  }

  @override
  bool areItemsTheSame(int oldItemPosition, int newItemPosition) {
    return itemEquality(oldList[oldItemPosition], newList[newItemPosition]);
  }
}

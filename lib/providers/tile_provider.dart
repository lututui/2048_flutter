import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/tile_grid.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:flutter_2048/widgets/tiles/movable_tile.dart';
import 'package:provider/provider.dart';

/// Describes a tile in a [TileGrid]
class TileProvider with ChangeNotifier {
  /// Creates a new tile with value [_value] and position [_gridPos]
  TileProvider(this._gridPos, this._value);

  /// Retrieves the nearest [TileProvider] in the Widget tree
  ///
  /// See [Provider.of] with `listen: false`
  factory TileProvider.of(BuildContext context) {
    return context.read<TileProvider>();
  }

  /// Creates a copy of [other]
  factory TileProvider.clone(TileProvider other) {
    return TileProvider(Tuple.copy(other._gridPos), other._value);
  }

  Tuple<int, int> _gridPos;
  int _value;

  /// Whether this tile should have its value updated when done moving
  bool pendingValueUpdate = false;

  /// Whether the widget for this tile is still moving
  bool moving = false;

  /// This tile value
  int get value => _value;

  /// The [Tuple] describing the position of this in a [TileGrid]
  Tuple<int, int> get gridPos => _gridPos;

  set gridPos(Tuple<int, int> value) {
    if (_gridPos == value) return;

    _log('Setting tile pos as $value (was $_gridPos)');

    _gridPos = value;
    moving = true;
    notifyListeners();
  }

  /// Called by the [MovableTile] that uses this provider when its done with
  /// the moving animation
  void onMoveEnd() {
    _log('Done moving');
    moving = false;

    if (pendingValueUpdate) updateValue();
  }

  /// Called to update this tile value
  void updateValue() {
    _log('Updating value');

    pendingValueUpdate = false;
    _value++;

    notifyListeners();
  }

  /// Whether [other] has the same tile value as this
  bool compareValue(Object other) {
    return other is TileProvider && _value == other._value;
  }

  @override
  String toString() => '0x${hashCode.toRadixString(16)}';

  void _log(String message) {
    Logger.log<TileProvider>(message, instance: this);
  }
}

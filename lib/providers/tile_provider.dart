import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:provider/provider.dart';

class TileProvider with ChangeNotifier {
  TileProvider(this._gridPos, this._value);

  factory TileProvider.of(BuildContext context) {
    return context.read<TileProvider>();
  }

  Tuple<int, int> _gridPos;
  int _value;

  bool pendingValueUpdate = false;
  bool moving = false;

  set value(int value) {
    if (_value == value) return;

    _value = value;
    notifyListeners();
  }

  set gridPos(Tuple<int, int> value) {
    if (_gridPos == value) return;

    log('Setting tile pos as $value (was $_gridPos)');

    _gridPos = value;
    moving = true;
    notifyListeners();
  }

  void onMoveEnd() {
    log('Done moving');
    moving = false;

    if (pendingValueUpdate) updateValue();
  }

  void updateValue() {
    log('Updating value');
    pendingValueUpdate = false;
    value++;
  }

  bool compareValue(Object other) {
    return other is TileProvider && _value == other._value;
  }

  @override
  String toString() => '0x${hashCode.toRadixString(16)}';

  int get value => _value;

  Tuple<int, int> get gridPos => _gridPos;

  void log(String message) {
    Logger.log<TileProvider>(message, instance: this);
  }

  TileProvider clone() {
    return TileProvider(Tuple.copy(_gridPos), _value);
  }
}

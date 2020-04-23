import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/util/data.dart';
import 'package:flutter_2048/util/tuple.dart';
import 'package:provider/provider.dart';

class TileProvider with ChangeNotifier {
  bool pendingValueUpdate = false;
  bool moving = false;
  Tuple<int, int> _gridPos;
  int _value;

  TileProvider._(this._value, this._gridPos);

  factory TileProvider(Tuple<int, int> pos, {int value}) {
    return TileProvider._(
      value ?? Data.SPAWN_VALUES[Data.rand.nextInt(Data.SPAWN_VALUES.length)],
      pos,
    );
  }

  factory TileProvider.of(BuildContext context, {bool listen = true}) {
    return Provider.of<TileProvider>(context, listen: listen);
  }

  int get value => _value;

  Tuple<int, int> get gridPos => _gridPos;

  set value(int value) {
    if (value == _value) return;

    _value = value;
    notifyListeners();
  }

  set gridPos(Tuple<int, int> value) {
    if (value == _gridPos) return;

    Logger.log<TileProvider>(
      "Setting tile pos as $value (was $_gridPos)",
      instance: this,
    );

    _gridPos = value;
    moving = true;
    notifyListeners();
  }

  void onMoveEnd() {
    Logger.log<TileProvider>("Done moving", instance: this);
    moving = false;

    if (this.pendingValueUpdate) updateValue();
  }

  void updateValue() {
    this.pendingValueUpdate = false;
    this.value++;
  }

  @override
  String toString() {
    return "0x${hashCode.toRadixString(16)}";
  }

  bool compareValue(Object other) {
    return other is TileProvider && this.value == other.value;
  }
}

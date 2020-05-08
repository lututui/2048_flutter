import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:provider/provider.dart';

class TileProvider with ChangeNotifier {
  Tuple<int, int> _gridPos;
  int _value;

  bool pendingValueUpdate = false;
  bool moving = false;

  TileProvider(
    this._gridPos, {
    int value,
  }) : _value = value ?? Misc.pickSpawnValue();

  factory TileProvider.of(BuildContext context) {
    return Provider.of<TileProvider>(context, listen: false);
  }

  set value(int value) {
    if (this._value == value) return;

    this._value = value;
    notifyListeners();
  }

  set gridPos(Tuple<int, int> value) {
    if (this._gridPos == value) return;

    this.log("Setting tile pos as $value (was $_gridPos)");

    this._gridPos = value;
    moving = true;
    notifyListeners();
  }

  void onMoveEnd() {
    this.log("Done moving");
    moving = false;

    if (this.pendingValueUpdate) updateValue();
  }

  void updateValue() {
    this.log("Updating value");
    this.pendingValueUpdate = false;
    this.value++;
  }

  bool compareValue(Object other) {
    return other is TileProvider && this._value == other._value;
  }

  @override
  String toString() => "0x${hashCode.toRadixString(16)}";

  int get value => _value;

  Tuple<int, int> get gridPos => _gridPos;

  void log(String message) {
    Logger.log<TileProvider>(message, instance: this);
  }
}

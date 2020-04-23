import 'package:flutter_2048/util/tuple.dart';

abstract class BaseTileProvider {
  Tuple<int, int> _gridPos;
  int _value;

  BaseTileProvider(this._gridPos, this._value);

  int get value => _value;

  set value(int value) {
    if (value == _value) return;
    _value = value;
  }

  Tuple<int, int> get gridPos => _gridPos;

  set gridPos(Tuple<int, int> value) {
    if (value == _gridPos) return;

    _gridPos = value;
  }

  @override
  String toString() {
    return "0x${hashCode.toRadixString(16)}";
  }
}

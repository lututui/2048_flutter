import 'dart:math';

import 'package:flutter/cupertino.dart';

class Data {
  static const List<int> SPAWN_VALUES = const [0, 1, 2];
  static const int LEADERBOARD_SIZE = 10;

  static final Random rand = Random();

  Data._();
}

extension RandomExtension on Random {
  int nextIntRanged({@required int min, @required int max}) {
    ArgumentError.checkNotNull(min, 'min');
    ArgumentError.checkNotNull(max, 'max');

    if (min > max) {
      throw RangeError(
        "min ($min) value should be greater or equal to max ($max) value",
      );
    }

    return min + this.nextInt(max - min);
  }
}

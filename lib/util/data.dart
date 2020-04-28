import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_2048/util/tuple.dart';

class Data {
  static const int _WEIGHT_SUM = 10 + 20 + 5;
  static const List<ImmutableTuple<int, int>> _SPAWN_VALUES = const [
    const ImmutableTuple(0, 10),
    const ImmutableTuple(1, 20),
    const ImmutableTuple(2, 5),
  ];
  static const int LEADERBOARD_SIZE = 10;

  static final Random rand = Random();

  static int pickSpawnValue() {
    return rand.pickWithWeight(_SPAWN_VALUES, weightSum: _WEIGHT_SUM);
  }

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

  T pickWithWeight<T>(List<ImmutableTuple<T, int>> options, {int weightSum}) {
    weightSum ??= options.fold(0, (v, element) => v += element.b);

    int picked = this.nextInt(weightSum);
    int j = 0;

    for (; picked >= options[j].b && j < options.length; j++) {
      picked -= options[j].b;
    }

    return options[j].a;
  }
}

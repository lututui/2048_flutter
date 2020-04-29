import 'dart:math';

import 'package:flutter_2048/types/extensions.dart';
import 'package:flutter_2048/types/tuple.dart';

class Misc {
  static int _weightSum;
  static List<Tuple<int, int>> _spawnValues = [
    Tuple(0, 10),
    Tuple(1, 20),
    Tuple(2, 5),
  ];
  static const int LEADERBOARD_SIZE = 10;

  static final Random rand = Random();

  static int pickSpawnValue() {
    _weightSum ??= _spawnValues.fold(0, (v, element) => v += element.b);

    return rand.pickWithWeight(_spawnValues, weightSum: _weightSum);
  }

  Misc._();
}

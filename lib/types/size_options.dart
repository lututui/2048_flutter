import 'package:flutter/material.dart';
import 'package:flutter_2048/util/misc.dart';

class SizeOptions {
  const SizeOptions._({
    @required this.sideLength,
    @required this.description,
    @required this.spawnRates,
    @required this.maxSpawnWeight,
  });

  final int sideLength;
  final String description;
  final Map<int, int> spawnRates;
  final int maxSpawnWeight;

  static const SizeOptions size3x3 = SizeOptions._(
    sideLength: 3,
    description: '3x3',
    spawnRates: {0: 13, 1: 7},
    maxSpawnWeight: 13 + 7,
  );
  static const SizeOptions size4x4 = SizeOptions._(
    sideLength: 4,
    description: '4x4',
    spawnRates: {0: 15, 1: 12, 2: 3},
    maxSpawnWeight: 15 + 12 + 3,
  );
  static const SizeOptions size5x5 = SizeOptions._(
    sideLength: 5,
    description: '5x5',
    spawnRates: {0: 10, 1: 10, 2: 15, 3: 5},
    maxSpawnWeight: 10 + 10 + 15 + 3,
  );
  static const SizeOptions size7x7 = SizeOptions._(
    sideLength: 7,
    description: '7x7',
    spawnRates: {0: 5, 1: 15, 2: 30, 3: 10},
    maxSpawnWeight: 5 + 15 + 30 + 10,
  );

  static const List<SizeOptions> sizes = [size3x3, size4x4, size5x5, size7x7];

  static final Map<int, int> _indexBySideLength = {
    for (var sizeOption in sizes)
      sizeOption.sideLength: sizes.indexOf(sizeOption)
  };

  static List<Widget> buildChildren(BuildContext context) {
    return sizes.map<Widget>(
      (size) {
        return Text(
          size.description,
          style: Theme.of(context).textTheme.headline6,
        );
      },
    ).toList(growable: false);
  }

  static int getIndexBySideLength(int sideLength) {
    return _indexBySideLength.putIfAbsent(
      sideLength,
      () => throw Exception('Unknown size option with side length $sideLength'),
    );
  }

  static SizeOptions getSizeOptionBySideLength(int sideLength) {
    return sizes[getIndexBySideLength(sideLength)];
  }

  static int nextSpawnValueBySideLength(int sideLength) {
    return getSizeOptionBySideLength(sideLength).nextSpawnValue();
  }

  int nextSpawnValue() {
    return Misc.rand.pickWithWeight(spawnRates, maxSpawnWeight);
  }
}

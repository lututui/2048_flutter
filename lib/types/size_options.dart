import 'package:flutter/material.dart';
import 'package:flutter_2048/util/misc.dart';

/// A grid size option
// TODO: Merge with DimensionsProvider or
// TODO: make DimensionsProvider.gridSize an instance of SizeOptions or
// TODO: remove DimensionsProvider.gridSize somehow
class SizeOptions {
  const SizeOptions._(
    this.sideLength,
    this.description,
    this._spawnRates,
    this._maxSpawnWeight,
  );

  /// The [TileGrid] size
  final int sideLength;

  /// A description of this size
  final String description;

  final Map<int, int> _spawnRates;
  final int _maxSpawnWeight;

  /// A 3x3 grid
  static const SizeOptions size3x3 = SizeOptions._(
    3,
    '3x3',
    {0: 13, 1: 7},
    13 + 7,
  );

  /// A 4x4 grid
  static const SizeOptions size4x4 = SizeOptions._(
    4,
    '4x4',
    {0: 15, 1: 12, 2: 3},
    15 + 12 + 3,
  );

  /// A 5x5 grid
  static const SizeOptions size5x5 = SizeOptions._(
    5,
    '5x5',
    {0: 10, 1: 10, 2: 15, 3: 5},
    10 + 10 + 15 + 3,
  );

  /// A 7x7 grid
  static const SizeOptions size7x7 = SizeOptions._(
    7,
    '7x7',
    {0: 5, 1: 15, 2: 30, 3: 10},
    5 + 15 + 30 + 10,
  );

  /// All size options
  static const List<SizeOptions> sizes = [size3x3, size4x4, size5x5, size7x7];

  static final Map<int, int> _indexBySideLength = {
    for (final sizeOption in sizes)
      sizeOption.sideLength: sizes.indexOf(sizeOption)
  };

  /// Creates a widget with the description of the [index]-th size option
  static Widget buildDescription(BuildContext context, int index) {
    return Text(
      sizes[index].description,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  /// The index of the [SizeOptions] with given side length
  /// in [SizeOptions.sizes]
  static int getIndexBySideLength(int sideLength) {
    if (_indexBySideLength.containsKey(sideLength)) {
      return _indexBySideLength[sideLength];
    }

    throw Exception('Unknown size option with side length $sideLength');
  }

  /// Picks the next tile value to be spawned
  static int nextSpawnValueBySideLength(int sideLength) {
    final SizeOptions sizeOption = sizes[getIndexBySideLength(sideLength)];

    return Misc.rand.pickWithWeight(
      sizeOption._spawnRates,
      sizeOption._maxSpawnWeight,
    );
  }
}

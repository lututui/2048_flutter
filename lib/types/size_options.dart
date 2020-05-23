import 'package:flutter/material.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/leaderboard_tab.dart';

/// The fallback [SizeOption]
const SizeOption kDefaultSizeOption = SizeOption.size4x4;

/// A grid size option
class SizeOption {
  const SizeOption._(
    this.sideLength,
    this.description,
    this._spawnRates,
  );

  /// The [TileGrid] size
  final int sideLength;

  /// A description of this size
  final String description;

  final Map<int, int> _spawnRates;

  /// The index of this option in [sizes]
  int get index => _sizes.indexOf(this);

  int get _maxWeight {
    return _spawnRates.values.fold(0, (result, weight) => result += weight);
  }

  /// Picks the next tile value to be spawned
  int nextSpawnValue() => Misc.rand.pickWithWeight(_spawnRates, _maxWeight);

  /// A 3x3 grid
  static const SizeOption size3x3 = SizeOption._(
    3,
    '3x3',
    {0: 13, 1: 7},
  );

  /// A 4x4 grid
  static const SizeOption size4x4 = SizeOption._(
    4,
    '4x4',
    {0: 15, 1: 12, 2: 3},
  );

  /// A 5x5 grid
  static const SizeOption size5x5 = SizeOption._(
    5,
    '5x5',
    {0: 10, 1: 10, 2: 15, 3: 5},
  );

  /// A 7x7 grid
  static const SizeOption size7x7 = SizeOption._(
    7,
    '7x7',
    {0: 5, 1: 15, 2: 30, 3: 10},
  );

  /// All size options
  static const List<SizeOption> _sizes = [size3x3, size4x4, size5x5, size7x7];

  /// How many size options are available
  static int get amount => _sizes.length;

  /// Returns the [index]-th size option
  static SizeOption withIndex(int index) {
    assert(!index.isNegative);
    assert(index < _sizes.length);

    return _sizes[index];
  }

  /// Creates a widget with the description of the [index]-th size option
  static Widget buildDescription(BuildContext context, int index) {
    return Text(
      _sizes[index].description,
      style: Theme.of(context).textTheme.headline6,
    );
  }

  /// Wraps all [SizeOption.description] with the [Tab] widget
  static final List<Widget> tabs = [
    for (final sizeOption in _sizes) Tab(text: sizeOption.description)
  ];

  /// Creates a [LeaderboardTab] for every [SizeOption]
  static final List<Widget> tabViews = [
    for (final sizeOption in _sizes) LeaderboardTab(sizeOption.sideLength)
  ];
}

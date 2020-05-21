import 'dart:math';

import 'package:flutter/rendering.dart';

/// Extensions used by [Misc.rand]
extension RandomExtension on Random {
  /// Picks an integer between [min] (inclusive) and [max] (exclusive)
  int nextIntRanged(int min, int max) {
    ArgumentError.checkNotNull(min, 'min');
    ArgumentError.checkNotNull(max, 'max');

    if (min > max) {
      throw RangeError(
        'min ($min) value should be greater or equal to max ($max) value',
      );
    }

    return min + nextInt(max - min);
  }

  /// Picks a value [T] in a list of options
  ///
  /// If [remove] is true, removes the picked value from [options]
  T pick<T>(List<T> options, {bool remove = false}) {
    final int picked = nextInt(options.length);

    if (remove) return options.removeAt(picked);

    return options[picked];
  }

  /// Picks a value [T] in a map of options
  ///
  /// An entry in [options] should have a key of type [T] (an option to be
  /// picked) and a value of type int (the weight of that option). The greater
  /// the weight, the more likely that option will be picked.
  ///
  /// [weightSum] should be the sum of all [options.values]
  T pickWithWeight<T>(Map<T, int> options, int weightSum) {
    final entries = options.entries.toList();

    int picked = nextInt(weightSum);
    int j = 0;

    for (; picked >= entries[j].value && j < options.length; j++) {
      picked -= entries[j].value;
    }

    return entries[j].key;
  }
}

/// Extension used by some widgets to size themselves
extension BoxConstraintsExtension on BoxConstraints {
  /// The average between [minWidth] and [maxWidth]
  double get averageWidth => 0.5 * (minWidth + maxWidth);
}

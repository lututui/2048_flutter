import 'dart:math';
import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_2048/types/tuple.dart';
import 'package:meta/meta.dart';

extension RandomExtension on Random {
  int nextIntRanged({@required int max, int min = 0}) {
    ArgumentError.checkNotNull(min, 'min');
    ArgumentError.checkNotNull(max, 'max');

    if (min > max) {
      throw RangeError(
        'min ($min) value should be greater or equal to max ($max) value',
      );
    }

    return min + nextInt(max - min);
  }

  T pick<T>(List<T> options, {bool remove = false}) {
    final int picked = nextInt(options.length);

    if (remove) return options.removeAt(picked);

    return options[picked];
  }

  T pickWithWeight<T>(List<Tuple<T, int>> options, {int weightSum}) {
    weightSum ??= options.fold(0, (v, element) => v += element.b);

    int picked = nextInt(weightSum);
    int j = 0;

    for (; picked >= options[j].b && j < options.length; j++) {
      picked -= options[j].b;
    }

    return options[j].a;
  }
}

extension NumListExtension on List<num> {
  num takeAverage() {
    if (isEmpty) {
      throw Exception('Cannot take average of empty list');
    }

    return reduce((value, element) => value += element) / length;
  }
}

extension SizeExtension on Size {
  Size scale({double factor, double widthFactor, double heightFactor}) {
    if (factor == null && widthFactor == null && heightFactor == null) {
      return null;
    }

    double width = this.width;
    double height = this.height;

    if (widthFactor != null) {
      width *= widthFactor;
    }

    if (heightFactor != null) {
      height *= heightFactor;
    }

    if (factor != null) {
      width *= factor;
      height *= factor;
    }

    return Size(width, height);
  }
}

extension BoxConstraintsExtension on BoxConstraints {
  double get averageWidth => 0.5 * (minWidth + maxWidth);
}

import 'dart:ui';

class Lists {
  const Lists._();

  static num takeAverage(List<num> list) {
    if (list == null || list.isEmpty)
      throw Exception("Cannot take average of empty list");

    return list.reduce((value, element) => value += element) / list.length;
  }
}

class Sizes {
  const Sizes._();

  static Size scale(
    Size s, {
    double factor,
    double widthFactor,
    double heightFactor,
  }) {
    if (s == null) return null;

    double width = s.width;
    double height = s.height;

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

import 'package:flutter/material.dart';

class SizeOptions {
  final int sideLength;
  final String description;

  const SizeOptions._({@required this.sideLength, @required this.description});

  static const SizeOptions SIZE_3x3 = const SizeOptions._(
    sideLength: 3,
    description: "3x3",
  );
  static const SizeOptions SIZE_4x4 = const SizeOptions._(
    sideLength: 4,
    description: "4x4",
  );
  static const SizeOptions SIZE_5x5 = const SizeOptions._(
    sideLength: 5,
    description: "5x5",
  );
  static const SizeOptions SIZE_7x7 = const SizeOptions._(
    sideLength: 7,
    description: "7x7",
  );

  static const List<SizeOptions> SIZES = const <SizeOptions>[
    SIZE_3x3,
    SIZE_4x4,
    SIZE_5x5,
    SIZE_7x7
  ];

  static List<Widget> getChildren() {
    return SIZES
        .map<Widget>((size) => Text(size.description))
        .toList(growable: false);
  }

  static int getSizeIndexBySideLength(int length) {
    return SIZES.indexWhere((e) => e.sideLength == length);
  }
}

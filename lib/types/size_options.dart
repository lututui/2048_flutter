import 'package:flutter/material.dart';

class SizeOptions {
  final int sideLength;
  final Widget child;

  const SizeOptions._({@required this.sideLength, @required this.child});

  static const SizeOptions SIZE_3x3 = const SizeOptions._(
    sideLength: 3,
    child: const Text("3x3"),
  );
  static const SizeOptions SIZE_4x4 = const SizeOptions._(
    sideLength: 4,
    child: const Text("4x4"),
  );
  static const SizeOptions SIZE_5x5 = const SizeOptions._(
    sideLength: 5,
    child: const Text("5x5"),
  );
  static const SizeOptions SIZE_7x7 = const SizeOptions._(
    sideLength: 7,
    child: const Text("7x7"),
  );

  static const List<SizeOptions> SIZES = const <SizeOptions>[
    SIZE_3x3,
    SIZE_4x4,
    SIZE_5x5,
    SIZE_7x7
  ];

  static List<Widget> getChildren() {
    return SIZES.map<Widget>((size) => size.child).toList(growable: false);
  }

  static int getSizeIndexBySideLength(int length) {
    return SIZES.indexWhere((e) => e.sideLength == length);
  }
}

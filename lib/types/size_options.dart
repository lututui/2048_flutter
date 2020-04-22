import 'package:flutter/material.dart';

class SizeOptions {
  final int sideLength;
  final Widget widget;

  const SizeOptions._(this.sideLength, this.widget);

  static const SizeOptions SIZE_3x3 = const SizeOptions._(3, const Text("3x3"));
  static const SizeOptions SIZE_4x4 = const SizeOptions._(4, const Text("4x4"));
  static const SizeOptions SIZE_5x5 = const SizeOptions._(5, const Text("5x5"));
  static const SizeOptions SIZE_7x7 = const SizeOptions._(7, const Text("7x7"));

  static const List<SizeOptions> SIZES = const <SizeOptions>[
    SIZE_3x3,
    SIZE_4x4,
    SIZE_5x5,
    SIZE_7x7
  ];
}

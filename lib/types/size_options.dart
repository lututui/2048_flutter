import 'package:flutter/material.dart';

class SizeOptions {
  const SizeOptions._({@required this.sideLength, @required this.description});

  final int sideLength;
  final String description;

  static const SizeOptions size3x3 = SizeOptions._(
    sideLength: 3,
    description: '3x3',
  );
  static const SizeOptions size4x4 = SizeOptions._(
    sideLength: 4,
    description: '4x4',
  );
  static const SizeOptions size5x5 = SizeOptions._(
    sideLength: 5,
    description: '5x5',
  );
  static const SizeOptions size7x7 = SizeOptions._(
    sideLength: 7,
    description: '7x7',
  );

  static const List<SizeOptions> sizes = <SizeOptions>[
    size3x3,
    size4x4,
    size5x5,
    size7x7
  ];

  static List<Widget> getChildren(BuildContext context) {
    return sizes.map<Widget>(
      (size) {
        return Text(
          size.description,
          style: Theme.of(context).textTheme.headline6,
        );
      },
    ).toList(growable: false);
  }

  static int getSizeIndexBySideLength(int length) {
    return sizes.indexWhere((e) => e.sideLength == length);
  }
}

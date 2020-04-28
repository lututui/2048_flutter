import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_2048/types/callbacks.dart';
import 'package:flutter_2048/util/palette.dart';

class SquareIconButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final VoidContextCallback onPress;
  final IconData icon;
  final double maxSize;
  final double borderWidth;

  SquareIconButton({
    Key key,
    @required this.color,
    @required this.onPress,
    @required this.icon,
    @required this.maxSize,
    Color borderColor,
    this.borderWidth = 3.0,
  })  : borderColor = borderColor ?? Palette.darkenColor(color),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.maxSize,
      height: this.maxSize,
      decoration: BoxDecoration(
        color: this.color,
        border: Border.fromBorderSide(
          BorderSide(
            color: this.borderColor,
            width: this.borderWidth,
          ),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          padding: const EdgeInsets.all(8.0),
          onPressed: () => this.onPress(context),
          icon: LayoutBuilder(
            builder: (context, constraints) {
              return Icon(
                this.icon,
                size: min(constraints.maxHeight, constraints.maxWidth),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'dart:math';

import 'package:flutter/material.dart';

typedef OnPressCallback = void Function(BuildContext);

class SquareIconButton extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final OnPressCallback onPress;
  final IconData iconData;
  final double maxSize;
  final double borderWidth;

  const SquareIconButton({
    Key key,
    @required this.onPress,
    @required this.iconData,
    @required this.maxSize,
    this.color,
    this.borderColor,
    this.borderWidth = 3.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        this.color ?? Theme.of(context).colorScheme.primary;
    final Color borderColor =
        this.borderColor ?? Theme.of(context).colorScheme.primaryVariant;

    return Container(
      width: this.maxSize,
      height: this.maxSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(color: borderColor, width: this.borderWidth),
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
                this.iconData,
                size: min(constraints.maxHeight, constraints.maxWidth),
              );
            },
          ),
        ),
      ),
    );
  }
}

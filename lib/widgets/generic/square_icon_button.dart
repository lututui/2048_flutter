import 'dart:math';

import 'package:flutter/material.dart';

typedef OnPressCallback = void Function(BuildContext);

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    @required this.onPress,
    @required this.iconData,
    @required this.maxSize,
    this.color,
    this.borderColor,
    this.borderWidth = 3.0,
    Key key,
  }) : super(key: key);

  final Color color;
  final Color borderColor;
  final OnPressCallback onPress;
  final IconData iconData;
  final double maxSize;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        color ?? Theme.of(context).colorScheme.primary;
    final Color borderColor =
        this.borderColor ?? Theme.of(context).colorScheme.primaryVariant;

    return Container(
      width: maxSize,
      height: maxSize,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: IconButton(
          onPressed: () => onPress(context),
          icon: LayoutBuilder(
            builder: (context, constraints) {
              return Icon(
                iconData,
                size: min(constraints.maxHeight, constraints.maxWidth),
              );
            },
          ),
        ),
      ),
    );
  }
}

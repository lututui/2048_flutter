import 'dart:math';

import 'package:flutter/material.dart';

typedef OnPressCallback = void Function(BuildContext);

class SquareIconButton extends StatelessWidget {
  const SquareIconButton({
    @required this.onPress,
    @required this.iconData,
    @required this.maxSize,
    this.padding = const EdgeInsets.all(8.0),
    this.color,
    this.borderColor,
    this.borderWidth = 3.0,
    this.enabled = true,
    Key key,
  }) : super(key: key);

  final Color color;
  final Color borderColor;
  final OnPressCallback onPress;
  final IconData iconData;
  final double maxSize;
  final double borderWidth;
  final bool enabled;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = color ?? colorScheme.primary;
    final borderColor = this.borderColor ?? colorScheme.primaryVariant;

    return Padding(
      padding: padding,
      child: Container(
        constraints: BoxConstraints.loose(Size.square(maxSize)),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.fromBorderSide(
            BorderSide(color: borderColor, width: borderWidth),
          ),
        ),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: IconButton(
            onPressed: enabled ? () => onPress(context) : null,
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
      ),
    );
  }
}

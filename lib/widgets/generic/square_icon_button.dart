import 'dart:math';

import 'package:flutter/material.dart';

typedef OnPressCallback = void Function(BuildContext);

/// An [IconButton] which forces its shape to be square
class SquareIconButton extends StatelessWidget {
  /// Creates a new square icon button
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

  /// The button background color
  final Color color;

  /// The border color of the button
  final Color borderColor;

  /// Callback function called when the button is pressed
  final OnPressCallback onPress;

  /// The icon to be shown
  final IconData iconData;

  /// The max size of this button
  ///
  /// This constraint is loose
  final double maxSize;

  /// The width to draw [borderColor]
  final double borderWidth;

  /// Whether this button can be activated
  final bool enabled;

  /// Padding to place around the button
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

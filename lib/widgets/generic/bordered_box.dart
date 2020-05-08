import 'package:flutter/material.dart';

class BorderedBox extends StatelessWidget {
  const BorderedBox({
    Key key,
    this.child,
    this.padding = EdgeInsets.zero,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    double height,
    double width,
    this.alignment = Alignment.center,
    this.rectifySize = true,
  })  : _height = height,
        _width = width,
        super(key: key);

  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double _height;
  final double _width;
  final AlignmentGeometry alignment;
  final bool rectifySize;

  double get height {
    if (_height == null || !rectifySize) return _height;

    return _height + 2 * borderWidth;
  }

  double get width {
    if (_width == null || !rectifySize) return _width;

    return _width + 2 * borderWidth;
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor =
        this.backgroundColor ?? Theme.of(context).colorScheme.primary;
    final Color borderColor =
        this.borderColor ?? Theme.of(context).colorScheme.primaryVariant;

    return Container(
      padding: padding,
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(color: borderColor, width: borderWidth),
        ),
      ),
      alignment: alignment,
      child: child,
    );
  }
}

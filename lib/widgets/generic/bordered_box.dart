import 'package:flutter/material.dart';

class BorderedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double _height;
  final double _width;
  final AlignmentGeometry alignment;
  final bool rectifySize;

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
    return Container(
      padding: this.padding,
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        color: this.backgroundColor,
        border: Border.fromBorderSide(
          BorderSide(
            color: this.borderColor,
            width: this.borderWidth,
          ),
        ),
      ),
      child: this.child,
      alignment: this.alignment,
    );
  }
}

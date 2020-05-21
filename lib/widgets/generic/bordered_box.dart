import 'package:flutter/material.dart';

/// A shorthand for a [Container] with a colored [Border]
class BorderedBox extends StatelessWidget {
  /// Creates a new bordered box
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

  /// This widget's child
  final Widget child;

  /// Padding to place around [child]
  final EdgeInsets padding;

  /// The background color for this container
  final Color backgroundColor;

  /// The border color for this container
  final Color borderColor;

  /// The width to paint the [borderColor]
  final double borderWidth;

  /// How [child] should be aligned
  final AlignmentGeometry alignment;

  /// Whether [height] and [width] should be inflated by [borderWidth]
  final bool rectifySize;

  final double _height;
  final double _width;

  /// The tight height constraint for this container
  double get height {
    if (_height == null || !rectifySize) return _height;

    return _height + 2 * borderWidth;
  }

  /// The tight width constraint for this container
  double get width {
    if (_width == null || !rectifySize) return _width;

    return _width + 2 * borderWidth;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = this.backgroundColor ?? colorScheme.primary;
    final borderColor = this.borderColor ?? colorScheme.primaryVariant;

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

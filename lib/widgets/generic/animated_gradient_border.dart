import 'dart:ui';

import 'package:flutter/material.dart';

/// A widget that creates a border around its [child] animated with
/// two [Gradient]s
class AnimatedGradientBorder extends StatefulWidget {
  /// Creates a new animated gradient border widget
  const AnimatedGradientBorder({
    @required this.child,
    @required this.gradientStart,
    @required this.gradientEnd,
    @required this.width,
    @required this.height,
    @required this.borderWidth,
    this.duration = const Duration(seconds: 2),
    this.borderRadius,
    Key key,
  }) : super(key: key);

  /// This widget's child
  final Widget child;

  /// The initial gradient
  final Gradient gradientStart;

  /// The final gradient
  final Gradient gradientEnd;

  /// Tight width constraint
  final double width;

  /// Tight height constraint
  final double height;

  /// Animated border width
  final double borderWidth;

  /// Animation duration
  final Duration duration;

  /// Radius to round borders
  final BorderRadiusGeometry borderRadius;

  @override
  _AnimatedGradientBorderState createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: Gradient.lerp(
              widget.gradientStart,
              widget.gradientEnd,
              _controller.value,
            ),
            borderRadius: widget.borderRadius,
          ),
          constraints: BoxConstraints.tightFor(
            width: widget.width,
            height: widget.height,
          ),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Container(
        constraints: BoxConstraints.tightFor(
          width: widget.width - widget.borderWidth,
          height: widget.height - widget.borderWidth,
        ),
        child: widget.child,
      ),
    );
  }
}

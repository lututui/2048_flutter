import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
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

  final Widget child;
  final Gradient gradientStart;
  final Gradient gradientEnd;
  final double width;
  final double height;
  final double borderWidth;
  final Duration duration;
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

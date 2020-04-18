import 'package:flutter/material.dart';

class BorderedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final double height;
  final double width;

  const BorderedBox({
    @required this.child,
    this.padding,
    this.backgroundColor = const Color(0xffb2ebf2),
    this.borderColor = const Color(0xff26c6da),
    this.borderWidth = 1.0,
    this.height,
    this.width,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
      width: (this.width != null) ? this.width + 2 * this.borderWidth : null,
      height: (this.height != null) ? this.width + 2 * this.borderWidth : null,
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
    );
  }
}

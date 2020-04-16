import 'package:flutter/material.dart';

class BorderedBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Alignment alignment;
  final double height;

  const BorderedBox({
    @required this.child,
    this.padding = const EdgeInsets.all(2.0),
    this.backgroundColor = const Color(0xffb2ebf2),
    this.borderColor = const Color(0xff26c6da),
    this.borderWidth = 1.0,
    this.alignment = Alignment.centerRight,
    this.height,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.padding,
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
      child: FittedBox(
        alignment: this.alignment,
        child: this.child,
      ),
    );
  }
}

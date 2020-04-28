import 'package:flutter/material.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/generic/fixed_width_text.dart';

class UnplacedTile extends StatelessWidget {
  const UnplacedTile({
    Key key,
    @required this.color,
    @required this.borderColor,
    @required this.borderWidth,
    @required this.height,
    @required this.width,
    @required this.text,
  }) : super(key: key);

  final Color color;
  final Color borderColor;
  final double borderWidth;
  final double height;
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      backgroundColor: this.color,
      borderColor: this.borderColor,
      borderWidth: this.borderWidth,
      height: this.height,
      width: this.width,
      rectifySize: false,
      child: FixedWidthText(
        width: this.width,
        inlineSpan: TextSpan(
          text: this.text,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

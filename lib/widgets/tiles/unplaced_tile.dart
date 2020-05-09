import 'package:flutter/material.dart';
import 'package:flutter_2048/types/tile_color.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/generic/fixed_width_text.dart';

class UnplacedTile extends StatelessWidget {
  const UnplacedTile({
    @required this.color,
    @required this.borderWidth,
    @required this.height,
    @required this.width,
    @required this.text,
    Key key,
  }) : super(key: key);

  final TileColor color;
  final double borderWidth;
  final double height;
  final double width;
  final String text;

  @override
  Widget build(BuildContext context) {
    return BorderedBox(
      backgroundColor: color.backgroundColor,
      borderColor: color.borderColor,
      borderWidth: borderWidth,
      height: height,
      width: width,
      rectifySize: false,
      child: FixedWidthText(
        width: width,
        inlineSpan: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Misc.calculateTextColor(color.backgroundColor),
          ),
        ),
      ),
    );
  }
}

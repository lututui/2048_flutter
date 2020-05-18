import 'package:flutter/material.dart';
import 'package:flutter_2048/types/tile_color.dart';
import 'package:flutter_2048/util/colors.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/generic/fixed_width_text.dart';

class UnplacedTile extends StatelessWidget {
  factory UnplacedTile({
    TileColor color,
    String text,
    double size,
    double borderSize,
    bool animate,
    Duration duration,
    Key key,
  }) {
    ArgumentError.checkNotNull(color, 'Tile color');
    ArgumentError.checkNotNull(text, 'Tile text');
    ArgumentError.checkNotNull(size, 'Tile size');

    return UnplacedTile._(
      color,
      text,
      size,
      borderSize ?? 1.0,
      (animate ?? true) ? duration ?? const Duration(milliseconds: 100) : null,
      (animate ?? true) ? Tween<double>(begin: 0.0, end: size) : null,
      key,
    );
  }

  const UnplacedTile._(
    this.color,
    this.text,
    this.size,
    this.borderSize,
    this.duration,
    this.sizeTween,
    Key key,
  ) : super(key: key);

  final TileColor color;
  final String text;
  final double size;
  final double borderSize;

  final Duration duration;
  final Tween<double> sizeTween;

  @override
  Widget build(BuildContext context) {
    if (sizeTween == null) {
      return BorderedBox(
        backgroundColor: color.backgroundColor,
        borderColor: color.borderColor,
        borderWidth: borderSize,
        height: size,
        width: size,
        rectifySize: false,
        child: FixedWidthText(
          width: size,
          inlineSpan: TextSpan(
            text: text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: ColorsUtil.calculateTextColor(color.backgroundColor),
            ),
          ),
        ),
      );
    }

    return TweenAnimationBuilder<double>(
      tween: sizeTween,
      duration: duration,
      builder: (context, value, _) {
        final translation = 0.5 - value / (2 * size);

        return Transform.translate(
          offset: Offset(translation, translation) * size,
          child: BorderedBox(
            backgroundColor: color.backgroundColor,
            borderColor: color.borderColor,
            borderWidth: borderSize,
            height: value,
            width: value,
            rectifySize: false,
            child: FixedWidthText(
              width: value,
              inlineSpan: TextSpan(
                text: text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: ColorsUtil.calculateTextColor(color.backgroundColor),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

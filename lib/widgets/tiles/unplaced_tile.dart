import 'package:flutter/material.dart';
import 'package:flutter_2048/types/tile_color.dart';
import 'package:flutter_2048/util/colors.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:flutter_2048/widgets/generic/fixed_width_text.dart';
import 'package:flutter_2048/widgets/tiles/immovable_tile.dart';
import 'package:flutter_2048/widgets/tiles/movable_tile.dart';

/// A tile widget that is not positioned.
///
/// When first built, will implicitly animate its size if [duration] is not
/// null.
///
/// For positioned versions see [MovableTile] and [ImmovableTile].
class UnplacedTile extends StatelessWidget {
  /// Creates a new unplaced tile widget
  ///
  /// Passing [animate] as false will prevent this widget from animating its
  /// size from 0 to [size], and any provided [duration] will be ignored.
  ///
  /// If [animate] is true or null, this tile will animate its size for the
  /// provided [duration] or for 100 milliseconds.
  factory UnplacedTile({
    TileColor color,
    String text,
    double size,
    double borderSize = 1.0,
    bool animate = true,
    Duration duration = const Duration(milliseconds: 100),
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
      key,
    );
  }

  const UnplacedTile._(
    this.color,
    this.text,
    this.size,
    this.borderSize,
    this.duration,
    Key key,
  ) : super(key: key);

  /// The colors used to paint this widget
  final TileColor color;

  /// The text centered inside this widget
  final String text;

  /// The size of this tile
  final double size;

  /// The border size of this tile
  final double borderSize;

  /// The size animation duration
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    if (duration == null) {
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
      tween: Tween<double>(begin: 0.0, end: size),
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

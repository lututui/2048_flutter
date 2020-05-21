import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/generic/animated_text.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:provider/provider.dart';

/// A widget that shows the current game score above [GameGrid]
class Scoreboard extends StatelessWidget {
  /// Creates a new scoreboard widget
  const Scoreboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, scoreText) {
        final double gapSize = dimensions.gapSize;
        final double gameSize = dimensions.gameSize;

        return Container(
          width: gameSize + gapSize,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BorderedBox(
                borderWidth: gapSize / 2,
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'Score',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              BorderedBox(
                borderWidth: gapSize / 2,
                padding: const EdgeInsets.all(2.0),
                child: scoreText,
              ),
            ],
          ),
        );
      },
      child: Consumer<GridProvider>(
        builder: (context, grid, _) {
          return AnimatedText(
            key: ObjectKey(grid),
            text: '${grid.score}',
            maxLines: 1,
            textAlign: TextAlign.right,
            textStyle: Theme.of(context).textTheme.headline6,
            tweenBuilder: ({String begin, String end}) => _ScoreTween(
              begin: begin,
              end: end,
            ),
          );
        },
      ),
    );
  }
}

class _ScoreTween extends Tween<String> {
  _ScoreTween({String begin, String end})
      : _internalTween = IntTween(
          begin: (begin == null) ? null : int.parse(begin),
          end: (end == null) ? null : int.parse(end),
        ),
        super(begin: begin, end: end);

  final IntTween _internalTween;

  @override
  set begin(String newBegin) {
    final int newIntBegin = int.parse(newBegin);

    if (newBegin != null) {
      assert(newIntBegin != null);
    }

    _internalTween.begin = newIntBegin;
    super.begin = newBegin;
  }

  @override
  set end(String newEnd) {
    final int newIntEnd = int.parse(newEnd);

    if (newEnd != null) {
      assert(newIntEnd != null);
    }

    _internalTween.end = newIntEnd;
    super.end = newEnd;
  }

  @override
  String lerp(double t) => _internalTween.lerp(t).toString();
}

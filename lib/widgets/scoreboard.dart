import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/grid_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/score_text.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);
    final int currentScore = GridProvider.of(context).score;

    return Container(
      width: dimensions.gameSize.width + dimensions.gapSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BorderedBox(
            child: const Text(
              "Score",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            backgroundColor: Palette.BOX_BACKGROUND,
            borderColor: Palette.BOX_BORDER,
            borderWidth: dimensions.gapSize.width / 2,
            padding: const EdgeInsets.all(2.0),
          ),
          BorderedBox(
            child: ScoreText(score: currentScore),
            backgroundColor: Palette.BOX_BACKGROUND,
            borderColor: Palette.BOX_BORDER,
            borderWidth: dimensions.gapSize.width / 2,
            padding: const EdgeInsets.all(2.0),
          ),
        ],
      ),
    );
  }
}

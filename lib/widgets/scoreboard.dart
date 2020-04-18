import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/score_text.dart';
import 'package:provider/provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = Provider.of<DimensionsProvider>(
      context,
    );
    final int currentScore = Provider.of<ScoreProvider>(context).value;

    return Container(
      width: dimensions.gameSize.width + dimensions.gapSize.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: dimensions.gapSize.width * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            BorderedBox(
              child: const Text(
                "Score",
                style: const TextStyle(
                  fontFamily: Fonts.RIGHTEOUS_FAMILY,
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
      ),
    );
  }
}

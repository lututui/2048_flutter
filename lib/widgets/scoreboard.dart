import 'package:flutter/material.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/mixins/game_ref_holder.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/score_text.dart';

class Scoreboard extends StatelessWidget with IGameRefHolder<Game2048> {
  @override
  final Game2048 gameRef;

  Scoreboard(this.gameRef);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: this.gameRef.gameBox.y - 8.0 * this.gapSize.height,
      left: this.gameRef.gameBox.x,
      width: this.gameRef.dimensions.gameSize.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          BorderedBox(
            child: const Text(
              "Score",
              style: const TextStyle(
                fontFamily: Fonts.RIGHTEOUS_FAMILY,
                fontSize: 20,
              ),
            ),
            backgroundColor: Palette.BOX_BACKGROUND.color,
            borderColor: Palette.BOX_BORDER.color,
            borderWidth: this.gapSize.width,
            alignment: Alignment.centerLeft,
            height: this.gameRef.dimensions.gapSize.height * 6,
          ),
          Spacer(flex: 1),
          Expanded(
            flex: 3,
            child: BorderedBox(
              child: ScoreText(this.gameRef),
              backgroundColor: Palette.BOX_BACKGROUND.color,
              borderColor: Palette.BOX_BORDER.color,
              borderWidth: this.gapSize.width,
              height: this.gameRef.dimensions.gapSize.height * 6,
            ),
          ),
        ],
      ),
    );
  }

  int get value => this.gameRef.score.value;

  ValueNotifier get score => this.gameRef.score;

  Size get gapSize => this.gameRef.dimensions.gapSize;
}

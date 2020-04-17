import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/game_over_dialog.dart';
import 'package:provider/provider.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<GridProvider>(context).gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => GameOverDialog.show(
          context,
          Provider.of<ScoreProvider>(context, listen: false).value,
        ),
      );
    }

    return Container(
      color: Palette.BOX_BACKGROUND,
      width: Provider.of<DimensionsProvider>(context).gameSize.width,
      height: Provider.of<DimensionsProvider>(context).gameSize.height,
      child: Stack(
        overflow: Overflow.visible,
        children: Provider.of<GridProvider>(context).tiles,
      ),
    );
  }
}
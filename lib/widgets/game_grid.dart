import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/game_over_dialog.dart';
import 'package:provider/provider.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = Provider.of<DimensionsProvider>(
      context,
    );
    final GridProvider grid = Provider.of<GridProvider>(context);

    if (grid.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) => GameOverDialog.show(
          context,
          Provider.of<ScoreProvider>(context, listen: false).value,
        ),
      );
    }

    return Center(
      child: BorderedBox(
        backgroundColor: Palette.BOX_BACKGROUND,
        borderColor: Palette.BOX_BORDER,
        width: dimensions.gameSize.width,
        height: dimensions.gameSize.height,
        borderWidth: dimensions.gapSize.width / 2,
        child: Stack(
          overflow: Overflow.visible,
          children: grid.tiles,
        ),
      ),
    );
  }
}

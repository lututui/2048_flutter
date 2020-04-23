import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid/base_grid_provider.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/grid_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/bordered_box.dart';
import 'package:flutter_2048/widgets/dialogs/game_over_dialog.dart';
import 'package:provider/provider.dart';

class GameGrid<T extends BaseGridProvider> extends StatelessWidget {
  const GameGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);
    final T grid = Provider.of<T>(context);

    if (grid is GridProvider && grid.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => GameOverDialog.show(context),
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

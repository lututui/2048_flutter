import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/widgets/dialogs/game_over_dialog.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:provider/provider.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Consumer<DimensionsProvider>(
        builder: (context, dimensions, _) {
          return BorderedBox(
            width: dimensions.gameSize.width,
            height: dimensions.gameSize.height,
            borderWidth: dimensions.gapSize.width * dimensions.gridSize / 3,
            child: Consumer<GridProvider>(
              builder: (context, grid, _) {
                if (grid.gameOver) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    GameOverDialog.show(
                      context,
                      grid.score,
                      dimensions.tileSize.width,
                      grid.saveState,
                    );
                  });
                }

                return Stack(
                  overflow: Overflow.visible,
                  children: grid.tiles,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
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
          final double gameSize = dimensions.getGameSize(context);

          return BorderedBox(
            width: gameSize,
            height: gameSize,
            borderWidth:
                dimensions.getGapSize(context) * dimensions.gridSize / 3,
            child: Consumer2<GridProvider, SettingsProvider>(
              builder: (context, grid, settings, _) {
                if (grid.gameOver) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    GameOverDialog.show(
                      context,
                      grid.score,
                      dimensions.getTileSize(context),
                      grid.saveState,
                    );

                    if (settings.autoReset) {
                      grid.saveState.wipe();
                    }
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

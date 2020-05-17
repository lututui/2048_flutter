import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/types/dialog_result.dart';
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
          final double gapSize = dimensions.getGapSize(context);
          final double tileSize = dimensions.getTileSize(context);

          return BorderedBox(
            width: gameSize,
            height: gameSize,
            borderWidth: gapSize * dimensions.gridSize / 3,
            child: Consumer2<GridProvider, SettingsProvider>(
              builder: (context, grid, settings, _) {
                if (grid.gameOver && !grid.shownGameOver) {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) => _showGameOverOnce(context, tileSize, grid, settings),
                  );
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

  void _showGameOverOnce(
    BuildContext context,
    double tileSize,
    GridProvider gridState,
    SettingsProvider settings,
  ) {
    assert(!gridState.shownGameOver);

    gridState.shownGameOver = true;

    GameOverDialog.show(
      context,
      (context) => GameOverDialog(
        finalScore: gridState.score,
        maxButtonSize: tileSize,
      ),
    ).then((result) {
      if (result == null || result == DialogResult.pause) {
        if (settings.autoReset) {
          gridState.saveState.wipe();
        }

        return;
      }

      if (result == DialogResult.exit) {
        if (settings.autoReset) {
          gridState.saveState.wipe();
        }
        Navigator.of(context).pop();
      } else if (result == DialogResult.reset) {
        gridState.saveState
            .wipe()
            .then((_) => Navigator.of(context).pushReplacementNamed('/game'));
      }
    });
  }
}

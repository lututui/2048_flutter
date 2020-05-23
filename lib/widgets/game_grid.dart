import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/widgets/dialogs/game_over_dialog.dart';
import 'package:flutter_2048/widgets/generic/bordered_box.dart';
import 'package:provider/provider.dart';

/// The main game widget, controlled by [GridProvider]
class GameGrid extends StatelessWidget {
  /// Creates a new game widget
  const GameGrid({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Consumer<DimensionsProvider>(
        builder: (context, dimensions, _) {
          final double gameSize = dimensions.gameSize;
          final double gapSize = dimensions.gapSize;
          final double tileSize = dimensions.tileSize;

          return BorderedBox(
            width: gameSize,
            height: gameSize,
            borderWidth: gapSize * dimensions.selectedSizeOption.sideLength / 3,
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
      if (result == null || result == DialogOption.pause) {
        if (settings.autoReset) {
          gridState.savedDataManager.wipe();
        }

        return;
      }

      if (result == DialogOption.exit) {
        if (settings.autoReset) {
          gridState.savedDataManager.wipe();
        }
        Navigator.of(context).pop();
      } else if (result == DialogOption.reset) {
        gridState.savedDataManager
            .wipe()
            .then((_) => Navigator.of(context).pushReplacementNamed('/game'));
      }
    });
  }
}

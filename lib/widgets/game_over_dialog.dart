import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/flexible_dialog_option.dart';
import 'package:flutter_2048/widgets/score_text.dart';
import 'package:provider/provider.dart';

class GameOverDialog extends StatelessWidget {
  final GridProvider gridState;
  final DimensionsProvider dimensionsState;

  const GameOverDialog({
    Key key,
    @required this.gridState,
    @required this.dimensionsState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.all(16.0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      title: Center(
        child: const Text(
          "Game Over",
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text(
              "Score:",
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
            ScoreText(score: this.gridState.score),
          ],
        ),
        Divider(
          color: Palette.BOX_BORDER.withAlpha(0xcc),
          indent: 16.0,
          endIndent: 16.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DialogOption(
              icon: DialogResult.EXIT.icon,
              callback: this._exit,
              color: Palette.BOX_BORDER,
              height: dimensionsState.tileSize.height,
              width: dimensionsState.tileSize.width,
            ),
            DialogOption(
              icon: DialogResult.RESET.icon,
              callback: this._reset,
              color: Palette.BOX_BORDER,
              height: dimensionsState.tileSize.height,
              width: dimensionsState.tileSize.width,
            ),
            DialogOption(
              icon: DialogResult.RESUME.icon,
              callback: this._resume,
              color: Palette.BOX_BORDER,
              height: dimensionsState.tileSize.height,
              width: dimensionsState.tileSize.width,
            ),
          ],
        ),
      ],
    );
  }

  void _resume(BuildContext context) {
    Navigator.of(context).pop(DialogResult.RESUME);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(DialogResult.RESET);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(DialogResult.EXIT);
  }

  static void show(BuildContext context) {
    final DimensionsProvider dimensions = Provider.of<DimensionsProvider>(
      context,
      listen: false,
    );

    showDialog<DialogResult>(
      context: context,
      barrierDismissible: true,
      builder: (c) {
        return GameOverDialog(
          gridState: Provider.of<GridProvider>(
            context,
            listen: false,
          ),
          dimensionsState: dimensions,
        );
      },
    ).then((result) async {
      if (result == null || result == DialogResult.RESUME) return;

      if (result == DialogResult.RESET) {
        await SaveManager.wipe(dimensions.gridSize);
        Navigator.of(context).pushReplacementNamed('/game4x4');
        return;
      }

      Navigator.of(context).pop();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/grid_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/dialog_option.dart';
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
      contentPadding: const EdgeInsets.all(0.0),
      title: const Center(
        child: const Text(
          "Game Over",
          style: const TextStyle(
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
        ChangeNotifierProvider.value(
          value: this.dimensionsState,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Container(
                  width: constraints.maxWidth,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DialogOption.square(
                            icon: DialogResult.EXIT.icon,
                            callback: this._exit,
                            color: Palette.BOX_BORDER,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DialogOption.square(
                            icon: DialogResult.RESET.icon,
                            callback: this._reset,
                            color: Palette.BOX_BORDER,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DialogOption.square(
                            icon: DialogResult.PAUSE.icon,
                            callback: this._resume,
                            color: Palette.BOX_BORDER,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  void _resume(BuildContext context) {
    Navigator.of(context).pop(DialogResult.PAUSE);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(DialogResult.RESET);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(DialogResult.EXIT);
  }

  static Future<void> show(BuildContext context) async {
    final DimensionsProvider dimensions = DimensionsProvider.of(
      context,
      listen: false,
    );

    return showDialog<DialogResult>(
      context: context,
      barrierDismissible: true,
      builder: (c) {
        return GameOverDialog(
          gridState: GridProvider.of(context, listen: false),
          dimensionsState: dimensions,
        );
      },
    ).then((result) async {
      if (result == null || result == DialogResult.PAUSE) return;

      if (result == DialogResult.RESET) {
        await SaveManager.wipeSave(dimensions.gridSize);
        Navigator.of(context).pushReplacementNamed(
          '/game',
          arguments: dimensions.gridSize,
        );
        return;
      }

      Navigator.of(context).pop();
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';

class GameOverDialog extends StatelessWidget {
  final int finalScore;
  final double maxButtonSize;

  const GameOverDialog({
    Key key,
    @required this.finalScore,
    @required this.maxButtonSize,
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
            Text(
              "$finalScore",
              maxLines: 1,
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
        Divider(
          color: Theme.of(context).colorScheme.secondary.withAlpha(0xcc),
          indent: 16.0,
          endIndent: 16.0,
        ),
        Padding(
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
                        child: SquareIconButton(
                          maxSize: this.maxButtonSize,
                          iconData: DialogResult.EXIT.icon,
                          onPress: this._exit,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SquareIconButton(
                          maxSize: this.maxButtonSize,
                          iconData: DialogResult.RESET.icon,
                          onPress: this._reset,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SquareIconButton(
                          maxSize: this.maxButtonSize,
                          iconData: DialogResult.PAUSE.icon,
                          onPress: this._resume,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
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

  static Future<void> show(
    BuildContext context,
    int score,
    double buttonSize,
    int gridSize,
  ) async {
    return showDialog<DialogResult>(
      context: context,
      barrierDismissible: true,
      builder: (c) {
        return GameOverDialog(
          finalScore: score,
          maxButtonSize: buttonSize,
        );
      },
    ).then((result) async {
      if (result == null || result == DialogResult.PAUSE) return;

      if (result == DialogResult.RESET) {
        await SaveManager.wipeSave(gridSize);
        Navigator.of(context).pushReplacementNamed(
          '/game',
          arguments: gridSize,
        );
        return;
      }

      Navigator.of(context).pop();
    });
  }
}

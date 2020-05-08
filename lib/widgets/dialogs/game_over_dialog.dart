import 'package:flutter/material.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';

class GameOverDialog extends StatelessWidget {
  const GameOverDialog({
    @required this.finalScore,
    @required this.maxButtonSize,
    Key key,
  }) : super(key: key);

  final int finalScore;
  final double maxButtonSize;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.all(16.0),
      contentPadding: const EdgeInsets.all(0.0),
      title: const Center(
        child: Text('Game Over', style: TextStyle(fontSize: 30)),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const Text('Score:', style: TextStyle(fontSize: 20)),
            Text(
              '$finalScore',
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
                          maxSize: maxButtonSize,
                          iconData: DialogResult.exit.icon,
                          onPress: _exit,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SquareIconButton(
                          maxSize: maxButtonSize,
                          iconData: DialogResult.reset.icon,
                          onPress: _reset,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SquareIconButton(
                          maxSize: maxButtonSize,
                          iconData: DialogResult.pause.icon,
                          onPress: _resume,
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
    Navigator.of(context).pop(DialogResult.pause);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(DialogResult.reset);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(DialogResult.exit);
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
      if (result == null || result == DialogResult.pause) return;

      if (result == DialogResult.reset) {
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

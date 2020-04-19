import 'package:flutter/material.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/pause.dart';
import 'package:flutter_2048/widgets/score_text.dart';

class GameOverDialog extends StatelessWidget {
  final int finalScore;
  final int gridSize;

  const GameOverDialog({
    Key key,
    @required this.finalScore,
    @required this.gridSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: const Text(
          "Game Over",
          style: TextStyle(
            fontFamily: Fonts.RIGHTEOUS_FAMILY,
            fontSize: 30,
          ),
        ),
      ),
      titlePadding: const EdgeInsets.all(16.0),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Score:",
              style: TextStyle(
                fontFamily: Fonts.RIGHTEOUS_FAMILY,
                fontSize: 20,
              ),
            ),
            ScoreText(score: this.finalScore),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Divider(
            indent: 10,
            endIndent: 10,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () => this._exit(context),
              child: Container(
                color: Palette.BOX_BORDER,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.keyboard_backspace),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => this._reset(context),
              child: Container(
                color: Palette.BOX_BORDER,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.settings_backup_restore),
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () => this._resume(context),
              child: Container(
                color: Palette.BOX_BORDER,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(Icons.pause),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _resume(BuildContext context) {
    Navigator.of(context).pop(PauseMenuResult.RESUME);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(PauseMenuResult.RESET);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(PauseMenuResult.EXIT);
  }

  static void show(BuildContext context, int score, int gridSize) {
    showDialog<PauseMenuResult>(
      context: context,
      barrierDismissible: true,
      builder: (c) {
        return GameOverDialog(finalScore: score, gridSize: gridSize);
      },
    ).then((result) async {
      if (result == null || result == PauseMenuResult.RESUME) return;

      if (result == PauseMenuResult.RESET) {
        await SaveManager.wipe(gridSize);
        Navigator.of(context).pushReplacementNamed('/game4x4');
        return;
      }

      Navigator.of(context).pop();
    });
  }
}

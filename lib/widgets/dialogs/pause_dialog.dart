import 'package:flutter/material.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';

class PauseDialog extends StatelessWidget {
  const PauseDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Center(
        child: const Text(
          "Paused",
          style: TextStyle(fontSize: 30),
        ),
      ),
      titlePadding: const EdgeInsets.all(24.0),
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: <Widget>[
        RaisedButton(
          onPressed: () => this._resume(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(DialogResult.PAUSE.icon),
              const Text("Resume"),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () => this._reset(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(DialogResult.RESET.icon),
              const Text("Reset"),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RaisedButton(
            onPressed: () => this._exit(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(DialogResult.EXIT.icon),
                const Text("Exit"),
              ],
            ),
          ),
        ),
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

  static Future<bool> show(BuildContext context, int gridSize) {
    return showDialog<DialogResult>(
      context: context,
      builder: (_) => const PauseDialog(),
    ).then(
      (result) {
        if (result != null && result == DialogResult.RESET) {
          SaveManager.wipeSave(gridSize);
          Navigator.of(context)
              .pushReplacementNamed('/game', arguments: gridSize);
        }

        return Future.value(result == DialogResult.EXIT);
      },
    );
  }
}

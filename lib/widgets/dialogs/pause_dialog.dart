import 'package:flutter/material.dart';
import 'package:flutter_2048/save_state.dart';
import 'package:flutter_2048/types/dialog_result.dart';

class PauseDialog extends StatelessWidget {
  const PauseDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Center(
        child: Text(
          'Paused',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      titlePadding: const EdgeInsets.all(24.0),
      backgroundColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
      children: <Widget>[
        RaisedButton(
          onPressed: () => _resume(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(DialogResult.pause.icon),
              const Text('Resume'),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () => _reset(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(DialogResult.reset.icon),
              const Text('Reset'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: RaisedButton(
            onPressed: () => _exit(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(DialogResult.exit.icon),
                const Text('Exit'),
              ],
            ),
          ),
        ),
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

  static Future<bool> show(BuildContext context, SaveState saveState) {
    return showDialog<DialogResult>(
      context: context,
      builder: (_) => const PauseDialog(),
    ).then(
      (result) {
        if (result != null && result == DialogResult.reset) {
          saveState.wipe();
          Navigator.of(context).pushReplacementNamed(
            '/game',
            arguments: saveState.gridSize,
          );
        }

        return Future.value(result == DialogResult.exit);
      },
    );
  }
}

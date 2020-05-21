import 'package:flutter/material.dart';
import 'package:flutter_2048/types/dialog_result.dart';

/// A widget to be shown as a dialog when the back button is pressed
/// in [GameScreen] or the pause button is pressed in [ButtonsBar]
class PauseDialog extends StatelessWidget {
  /// Creates a new pause dialog widget
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
              Icon(DialogOption.pause.icon),
              const Text('Resume'),
            ],
          ),
        ),
        RaisedButton(
          onPressed: () => _reset(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(DialogOption.reset.icon),
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
                Icon(DialogOption.exit.icon),
                const Text('Exit'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _resume(BuildContext context) {
    Navigator.of(context).pop(DialogOption.pause);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(DialogOption.reset);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(DialogOption.exit);
  }
}

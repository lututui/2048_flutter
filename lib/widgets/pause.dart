import 'package:flutter/material.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';

enum PauseMenuResult { RESUME, RESET, EXIT }

class PauseMenu extends StatelessWidget {
  static const TextStyle _textStyle = const TextStyle(
    fontFamily: Fonts.RIGHTEOUS_FAMILY,
  );

  const PauseMenu();

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text("Paused", style: PauseMenu._textStyle),
      backgroundColor: Palette.PAUSE_BACKGROUND,
      children: <Widget>[
        RaisedButton(
          onPressed: () => this._resume(context),
          child: const Text("Resume", style: PauseMenu._textStyle),
        ),
        RaisedButton(
          onPressed: () => this._reset(context),
          child: const Text("Reset", style: PauseMenu._textStyle),
        ),
        RaisedButton(
          onPressed: () => this._exit(context),
          child: const Text("Exit", style: PauseMenu._textStyle),
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
}

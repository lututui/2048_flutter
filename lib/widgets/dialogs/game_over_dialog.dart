import 'package:flutter/material.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';

/// A widget to be shown as a dialog when [GridProvider.gameOver] turns true
class GameOverDialog extends StatelessWidget {
  /// Creates a new game over dialog widget
  ///
  /// The final score and button size have to be provided since looking up
  /// ancestors in a dialog is unsafe
  const GameOverDialog({
    @required this.finalScore,
    @required this.maxButtonSize,
    Key key,
  }) : super(key: key);

  /// The final game score
  ///
  /// Matches [GridProvider.score] at the moment this widget is instantiated
  final int finalScore;

  /// The max size each of the buttons in this dialog can take
  final double maxButtonSize;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return SimpleDialog(
      titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      contentPadding: EdgeInsets.zero,
      title: Center(
        child: Text('Game Over', style: themeData.textTheme.headline4),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: Text(
                'Score:',
                style: themeData.textTheme.headline6,
              ),
            ),
            Expanded(
              child: Text(
                '$finalScore',
                maxLines: 1,
                textAlign: TextAlign.right,
                style: themeData.textTheme.headline6,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          child: Divider(
            color: themeData.colorScheme.onSurface.withAlpha(0x33),
          ),
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
                      SquareIconButton(
                        maxSize: maxButtonSize,
                        iconData: DialogOption.exit.icon,
                        onPress: _exit,
                      ),
                      SquareIconButton(
                        maxSize: maxButtonSize,
                        iconData: DialogOption.reset.icon,
                        onPress: _reset,
                      ),
                      SquareIconButton(
                        maxSize: maxButtonSize,
                        iconData: DialogOption.pause.icon,
                        onPress: _resume,
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
    Navigator.of(context).pop(DialogOption.pause);
  }

  void _reset(BuildContext context) {
    Navigator.of(context).pop(DialogOption.reset);
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop(DialogOption.exit);
  }

  /// Shorthand method to show this widget
  static Future<DialogOption> show(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return Future.delayed(
      const Duration(seconds: 1),
      () => Misc.showDialog<DialogOption>(context: context, builder: builder)
          .then((value) => value ?? DialogOption.pause),
    );
  }
}

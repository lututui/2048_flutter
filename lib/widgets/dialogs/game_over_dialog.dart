import 'package:flutter/material.dart';
import 'package:flutter_2048/logger.dart';
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
      titlePadding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
      contentPadding: EdgeInsets.zero,
      title: Center(
        child: Text('Game Over', style: Theme.of(context).textTheme.headline4),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: Text(
                'Score:',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Expanded(
              child: Text(
                '$finalScore',
                maxLines: 1,
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          child: Divider(
            color: Theme.of(context).colorScheme.onSurface.withAlpha(0x33),
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

  static Future<DialogResult> show(
    BuildContext context,
    WidgetBuilder builder,
  ) {
    return showDialog<DialogResult>(
      context: context,
      barrierDismissible: true,
      builder: builder,
    ).then((value) => value ?? DialogResult.exit);
  }

  static void log(String message) {
    Logger.log<GameOverDialog>(message);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';
import 'package:provider/provider.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, _) {
        return Container(
          width: dimensions.gameSize.width,
          child: AspectRatio(
            aspectRatio: dimensions.aspectRatio,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SquareIconButton(
                  onPress: this._exit,
                  iconData: DialogResult.EXIT.icon,
                  maxSize: dimensions.tileSize.width,
                ),
                SquareIconButton(
                  onPress: this._reset,
                  iconData: DialogResult.RESET.icon,
                  maxSize: dimensions.tileSize.width,
                ),
                SquareIconButton(
                  onPress: this._pause,
                  iconData: DialogResult.PAUSE.icon,
                  maxSize: dimensions.tileSize.width,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pause(BuildContext context) {
    PauseDialog.show(
      context,
      DimensionsProvider.getGridSize(context),
    ).then(
      (bool shouldPop) {
        if (!shouldPop) return;

        Navigator.of(context).pop();
      },
    );
  }

  void _reset(BuildContext context) {
    final int gridSize = DimensionsProvider.getGridSize(context);

    SaveManager.wipeSave(
      gridSize,
    ).then((_) {
      Navigator.of(context).pushReplacementNamed('/game', arguments: gridSize);
    });
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop();
  }
}

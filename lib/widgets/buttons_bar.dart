import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);

    final double barRatio = dimensions.gameSize.width /
        (dimensions.tileSize.height +
            dimensions.gridSize * dimensions.gapSize.width);

    return Container(
      width: dimensions.gameSize.width,
      child: AspectRatio(
        aspectRatio: barRatio,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SquareIconButton(
              onPress: this._exit,
              icon: DialogResult.EXIT.icon,
              maxSize: dimensions.tileSize.width,
              color: Palette.BOX_BACKGROUND,
              borderColor: Palette.BOX_BORDER,
            ),
            SquareIconButton(
              onPress: this._reset,
              icon: DialogResult.RESET.icon,
              maxSize: dimensions.tileSize.width,
              color: Palette.BOX_BACKGROUND,
              borderColor: Palette.BOX_BORDER,
            ),
            SquareIconButton(
              onPress: this._pause,
              icon: DialogResult.PAUSE.icon,
              maxSize: dimensions.tileSize.width,
              color: Palette.BOX_BACKGROUND,
              borderColor: Palette.BOX_BORDER,
            ),
          ],
        ),
      ),
    );
  }

  void _pause(BuildContext context) {
    PauseDialog.show(
      context,
      DimensionsProvider.of(context, listen: false).gridSize,
    ).then((bool shouldPop) {
      if (shouldPop) Navigator.of(context).pop();
    });
  }

  void _reset(BuildContext context) {
    final int gridSize = DimensionsProvider.of(context, listen: false).gridSize;

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

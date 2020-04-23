import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/dialog_option.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DimensionsProvider dimensions = DimensionsProvider.of(context);

    return Container(
      width: dimensions.gameSize.width + dimensions.gapSize.width,
      height: dimensions.tileSize.height + dimensions.gapSize.width,
      padding: EdgeInsets.only(top: dimensions.gapSize.height),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          DialogOption(
            height: dimensions.tileSize.height,
            color: Palette.BOX_BACKGROUND,
            callback: this._exit,
            icon: DialogResult.EXIT.icon,
          ),
          DialogOption(
            height: dimensions.tileSize.height,
            color: Palette.BOX_BACKGROUND,
            callback: this._reset,
            icon: DialogResult.RESET.icon,
          ),
          DialogOption(
            height: dimensions.tileSize.height,
            color: Palette.BOX_BACKGROUND,
            callback: this._pause,
            icon: DialogResult.PAUSE.icon,
          ),
        ],
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

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/dialog_option.dart';
import 'package:flutter_2048/widgets/pause_dialog.dart';

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
    );
  }

  void _reset(BuildContext context) {
    SaveManager.wipeSave(
      DimensionsProvider.of(context, listen: false).gridSize,
    ).then((_) {
      Navigator.of(context).pushReplacementNamed('/game4x4');
    });
  }

  void _exit(BuildContext context) {
    Navigator.of(context).pop();
  }
}

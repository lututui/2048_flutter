import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
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
          alignment: Alignment.center,
          child: AspectRatio(
            aspectRatio: dimensions.aspectRatio,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Consumer<GridProvider>(
                  builder: (context, grid, _) {
                    return SquareIconButton(
                      onPress: _undo,
                      enabled: grid.canUndo,
                      iconData: Icons.undo,
                      maxSize: 1 / 6 * dimensions.gameSize.width,
                    );
                  },
                ),
                SquareIconButton(
                  onPress: _pause,
                  iconData: DialogResult.pause.icon,
                  maxSize: 1 / 6 * dimensions.gameSize.width,
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
      GridProvider.of(context).saveState,
    ).then(
      (bool shouldPop) {
        if (!shouldPop) return;

        Navigator.of(context).pop();
      },
    );
  }

  void _undo(BuildContext context) {
    GridProvider.of(context).undo();
  }
}

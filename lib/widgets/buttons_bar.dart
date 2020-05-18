import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';
import 'package:provider/provider.dart';

class ButtonsBar extends StatelessWidget {
  const ButtonsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, _) {
        final double gameSize = dimensions.getGameSize(context);
        final double maxButtonSize = gameSize / 4;

        return Container(
          width: gameSize,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SquareIconButton(
                onPress: _back,
                iconData: DialogResult.exit.icon,
                maxSize: maxButtonSize,
                padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
              ),
              Consumer<GridProvider>(
                builder: (context, grid, _) {
                  return SquareIconButton(
                    onPress: _undo,
                    enabled: grid.canUndo,
                    iconData: Icons.undo,
                    maxSize: maxButtonSize,
                  );
                },
              ),
              SquareIconButton(
                onPress: _pause,
                iconData: DialogResult.pause.icon,
                maxSize: maxButtonSize,
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
              ),
            ],
          ),
        );
      },
    );
  }

  void _pause(BuildContext context) {
    Misc.showDialog<DialogResult>(
      context: context,
      builder: (_) => const PauseDialog(),
    ).then((result) {
      if (result == null || result == DialogResult.pause) return;

      if (result == DialogResult.exit) {
        Navigator.of(context).pop();
      } else if (result == DialogResult.reset) {
        GridProvider.of(context)
            .saveState
            .wipe()
            .then((_) => Navigator.of(context).pushReplacementNamed('/game'));
      }
    });
  }

  void _back(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _undo(BuildContext context) {
    GridProvider.of(context).undo();
  }
}

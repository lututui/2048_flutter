import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/generic/square_icon_button.dart';
import 'package:provider/provider.dart';

/// A group of [SquareIconButton]s displayed below [GameGrid]
///
/// The buttons are sized according to [DimensionsProvider.gameSize]
class ButtonsBar extends StatelessWidget {
  /// Creates a new ButtonsBar widget
  const ButtonsBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DimensionsProvider>(
      builder: (context, dimensions, _) {
        final double gameSize = dimensions.gameSize;
        final double maxButtonSize = gameSize / 4;

        return Container(
          width: gameSize,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SquareIconButton(
                onPress: _back,
                iconData: DialogOption.exit.icon,
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
                iconData: DialogOption.pause.icon,
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
    Misc.showDialog<DialogOption>(
      context: context,
      builder: (_) => const PauseDialog(),
    ).then((result) {
      if (result == null || result == DialogOption.pause) return;

      if (result == DialogOption.exit) {
        Navigator.of(context).pop();
      } else if (result == DialogOption.reset) {
        GridProvider.of(context)
            .savedDataManager
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

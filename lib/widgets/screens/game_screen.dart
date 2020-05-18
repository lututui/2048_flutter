import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/types/dialog_result.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/buttons_bar.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/generic/future_widget.dart';
import 'package:flutter_2048/widgets/scoreboard.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureWidget<GridProvider>(
        computation: () => GridProvider.fromJSON(context),
        loadingChild: Misc.buildLoadingWidget,
        onError: (error) => throw Exception('Something went wrong: $error'),
        builder: (context, snapshot) {
          return ChangeNotifierProvider<GridProvider>.value(
            value: snapshot.data,
            child: Consumer<GridProvider>(
              builder: (context, grid, _) {
                return WillPopScope(
                  onWillPop: () => _pause(context),
                  child: GestureDetector(
                    onVerticalDragEnd: (details) => grid.swipe(
                      details.velocity.pixelsPerSecond.dy < 0
                          ? SwipeGestureType.up
                          : SwipeGestureType.down,
                    ),
                    onHorizontalDragEnd: (details) => grid.swipe(
                      details.velocity.pixelsPerSecond.dx < 0
                          ? SwipeGestureType.left
                          : SwipeGestureType.right,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Scoreboard(),
                          GameGrid(),
                          ButtonsBar(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<bool> _pause(BuildContext context) {
    return PauseDialog.show(
      context,
      (_) => const PauseDialog(),
    ).then((result) {
      Future<bool> returnValue;

      if (result == null || result == DialogResult.pause) {
        returnValue = Future.value(false);
      } else if (result == DialogResult.exit) {
        returnValue = Future.value(true);
      } else if (result == DialogResult.reset) {
        GridProvider.of(context)
            .saveState
            .wipe()
            .then((_) => Navigator.of(context).pushReplacementNamed('/game'));
        returnValue = Future.value(false);
      }

      return returnValue;
    });
  }
}

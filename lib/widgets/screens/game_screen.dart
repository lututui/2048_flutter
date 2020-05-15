import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
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
                  onWillPop: () => PauseDialog.show(
                    context,
                    grid.saveState,
                  ),
                  child: GestureDetector(
                    onVerticalDragEnd: (i) => grid.onVerticalDragEnd(i),
                    onHorizontalDragEnd: (i) => grid.onHorizontalDragEnd(i),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid/grid_provider.dart';
import 'package:flutter_2048/util/palette.dart';
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
    return FutureWidget<GridProvider>(
      computation: () => GridProvider.fromJSON(context),
      loadingChild: Scaffold(
        backgroundColor: Palette.BACKGROUND,
        body: Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator(
            valueColor: const AlwaysStoppedAnimation<Color>(
              Palette.PROGRESS_INDICATOR_COLOR,
            ),
          ),
        ),
      ),
      onError: (error) => throw Exception("Something went wrong: $error"),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Palette.BACKGROUND,
          body: ChangeNotifierProvider<GridProvider>.value(
            value: snapshot.data,
            child: Consumer<GridProvider>(
              builder: (context, grid, child) {
                return WillPopScope(
                  onWillPop: () => PauseDialog.show(
                    context,
                    grid.grid.sideLength,
                  ),
                  child: GestureDetector(
                    onVerticalDragEnd: (i) => grid.onVerticalDragEnd(i),
                    onHorizontalDragEnd: (i) => grid.onHorizontalDragEnd(i),
                    behavior: HitTestBehavior.opaque,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          const Scoreboard(),
                          const GameGrid<GridProvider>(),
                          const ButtonsBar(),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

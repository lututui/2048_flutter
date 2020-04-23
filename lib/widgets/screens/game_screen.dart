import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/grid_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/buttons_bar.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/dialogs/pause_dialog.dart';
import 'package:flutter_2048/widgets/scoreboard.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
  final AsyncMemoizer<GridProvider> _memoizer = AsyncMemoizer();

  GameScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GridProvider>(
      future: _memoizer.runOnce(() => GridProvider.fromJSON(context)),
      builder: (futureContext, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Scaffold(
            backgroundColor: Palette.BACKGROUND,
            body: Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Palette.getRandomTileColor(),
                ),
              ),
            ),
          );

        if (snapshot.hasError || !snapshot.hasData)
          throw Exception("Something went wrong: ${snapshot.error}");

        return Scaffold(
          backgroundColor: Palette.BACKGROUND,
          body: MultiProvider(
            providers: [
              ChangeNotifierProvider<GridProvider>.value(
                value: snapshot.data,
              ),
            ],
            child: Builder(
              builder: (context) {
                final GridProvider state = GridProvider.of(context);

                return WillPopScope(
                  onWillPop: () => PauseDialog.show(
                    context,
                    DimensionsProvider.of(context, listen: false).gridSize,
                  ),
                  child: GestureDetector(
                    onVerticalDragEnd: (info) => state.onVerticalDragEnd(
                      info,
                    ),
                    onHorizontalDragEnd: (info) => state.onHorizontalDragEnd(
                      info,
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        const Scoreboard(),
                        const GameGrid<GridProvider>(),
                        const ButtonsBar(),
                      ],
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

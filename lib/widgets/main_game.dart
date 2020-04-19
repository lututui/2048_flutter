import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/save_manager.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/pause.dart';
import 'package:flutter_2048/widgets/scoreboard.dart';
import 'package:provider/provider.dart';

class MainGame extends StatelessWidget {
  final AsyncMemoizer<GridProvider> _memoizer = AsyncMemoizer();

  MainGame({Key key}) : super(key: key);

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
                return WillPopScope(
                  onWillPop: () => confirmReturn(context),
                  child: GestureDetector(
                    onVerticalDragEnd: (details) => Provider.of<GridProvider>(
                      context,
                      listen: false,
                    ).onVerticalDragEnd(details),
                    onHorizontalDragEnd: (details) => Provider.of<GridProvider>(
                      context,
                      listen: false,
                    ).onHorizontalDragEnd(details),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        const Scoreboard(),
                        const GameGrid(),
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

  Future<bool> confirmReturn(BuildContext context) {
    return showDialog<PauseMenuResult>(
      context: context,
      builder: (_) => const PauseMenu(),
    ).then((result) async {
      // Dismissed or resumed
      if (result == null || result == PauseMenuResult.RESUME)
        return Future.value(false);

      if (result == PauseMenuResult.RESET) {
        await SaveManager.wipe(
          Provider.of<DimensionsProvider>(context, listen: false).gridSize,
        );
        Navigator.of(context).pushReplacementNamed('/game4x4');
      }

      return Future.value(result == PauseMenuResult.EXIT);
    });
  }
}

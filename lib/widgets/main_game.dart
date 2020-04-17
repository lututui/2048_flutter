import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/grid_provider.dart';
import 'package:flutter_2048/providers/score_provider.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/game_grid.dart';
import 'package:flutter_2048/widgets/pause.dart';
import 'package:flutter_2048/widgets/scoreboard.dart';
import 'package:provider/provider.dart';

class MainGame extends StatelessWidget {
  const MainGame({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.BACKGROUND,
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider<ScoreProvider>(
            create: (_) => ScoreProvider(0),
          ),
          ChangeNotifierProvider<GridProvider>(
            create: (providerContext) => GridProvider(providerContext),
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
                ).onVerticalDragEnd(details, context),
                onHorizontalDragEnd: (details) => Provider.of<GridProvider>(
                  context,
                  listen: false,
                ).onHorizontalDragEnd(details, context),
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
  }

  Future<bool> confirmReturn(BuildContext context) {
    return showDialog<PauseMenuResult>(
      context: context,
      builder: (_) => const PauseMenu(),
    ).then((result) {
      print(result);
      // Dismissed or resumed
      if (result == PauseMenuResult.RESUME) return Future.value(false);

      if (result == PauseMenuResult.RESET) {
        Navigator.of(context).pushReplacementNamed('/game4x4');
      }

      return Future.value(result == PauseMenuResult.EXIT);
    });
  }
}

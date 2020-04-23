import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/dummy_game.dart';
import 'package:flutter_2048/widgets/main_menu_button.dart';
import 'package:flutter_2048/widgets/selector.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DummyGame(context),
            Selector(
              onSelectChange: (int selected) {
                DimensionsProvider.of(
                  context,
                  listen: false,
                ).gridSize = selected;
              },
              children: SizeOptions.SIZES,
              defaultOption: 1,
            ),
            Column(
              children: <Widget>[
                MainMenuButton(
                  routeName: '/game',
                  routeArgs: DimensionsProvider.of(context).gridSize,
                  buttonText: "Play",
                ),
                MainMenuButton(
                  routeName: '/leaderboard',
                  routeArgs: DimensionsProvider.of(context).gridSize,
                  buttonText: "Leaderboard",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

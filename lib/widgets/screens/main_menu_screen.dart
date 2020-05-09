import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/dummy_game.dart';
import 'package:flutter_2048/widgets/generic/selector.dart';
import 'package:flutter_2048/widgets/main_menu_button.dart';
import 'package:provider/provider.dart' hide Selector;

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  DummyGame.withSizes(SizeOptions.sizes.length),
                  Selector(
                    onSelectChange: (int selected) {
                      DimensionsProvider.setGridSize(
                        context,
                        SizeOptions.sizes[selected].sideLength,
                      );
                    },
                    defaultOption: SizeOptions.getSizeIndexBySideLength(
                      context.watch<DimensionsProvider>().gridSize,
                    ),
                    children: SizeOptions.getChildren(context),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Theme(
                data: Theme.of(context).copyWith(
                  buttonTheme: ButtonTheme.of(context).copyWith(
                    shape: const Border.fromBorderSide(BorderSide(width: 2.0)),
                  ),
                ),
                child: Column(
                  children: const <Widget>[
                    MainMenuButton(
                      routeName: '/game',
                      buttonText: 'Play',
                    ),
                    MainMenuButton(
                      routeName: '/leaderboard',
                      buttonText: 'Leaderboard',
                    ),
                    MainMenuButton(
                      routeName: '/settings',
                      buttonText: 'Settings',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

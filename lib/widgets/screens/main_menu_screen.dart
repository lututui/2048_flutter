import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    return Theme(
      data: Theme.of(context).copyWith(
        buttonTheme: ButtonTheme.of(context).copyWith(
          shape: const Border.fromBorderSide(
            BorderSide(width: 2.0),
          ),
        ),
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final double maxDummyHeight = 5 / 11 * constraints.maxHeight;

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: maxDummyHeight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: DummyGame.withSizes(SizeOptions.sizes.length),
                        ),
                      ),
                      Selector(
                        onSelectChange: (int selected) {
                          DimensionsProvider.setGridSize(
                            context,
                            SizeOptions.sizes[selected].sideLength,
                          );
                        },
                        defaultOption: SizeOptions.getSizeIndexBySideLength(
                          Provider.of<DimensionsProvider>(
                            context,
                            listen: false,
                          ).gridSize,
                        ),
                        children: SizeOptions.getChildren(context),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

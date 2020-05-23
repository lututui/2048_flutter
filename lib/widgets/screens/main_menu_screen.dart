import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/size_options.dart';
import 'package:flutter_2048/widgets/dummy_game.dart';
import 'package:flutter_2048/widgets/generic/selector.dart';
import 'package:flutter_2048/widgets/main_menu_button.dart';

/// The main menu screen widget
///
/// This is the app home
class MainMenuScreen extends StatelessWidget {
  /// Creates a new main menu widget
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
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 5 / 11 * constraints.maxHeight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: DummyGame.withSizes(SizeOption.amount),
                        ),
                      ),
                      Selector.builder(
                        onChange: DimensionsProvider.instance.selectSizeOption,
                        defaultOption: 1,
                        builder: SizeOption.buildDescription,
                        size: SizeOption.amount,
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

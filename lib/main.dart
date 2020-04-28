import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/dummy_holder_provider.dart';
import 'package:flutter_2048/route/main_menu_route_builder.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.enabled = false;

  runApp(const Main());
}

class Main extends StatelessWidget {
  static final dimensionsProvider = DimensionsProvider();
  static final dummyHolderProvider = DummyHolderProvider();

  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: Fonts.RIGHTEOUS_FAMILY,
        scaffoldBackgroundColor: Palette.BACKGROUND,
        tabBarTheme: const TabBarTheme(
          labelColor: Palette.TAB_BAR_THEME_COLOR,
        ),
        appBarTheme: const AppBarTheme(
          color: Palette.APP_BAR_THEME_COLOR,
        ),
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MainMenuRouteBuilder(
            dimensionsProvider: dimensionsProvider,
            dummyHolderProvider: dummyHolderProvider,
            pageBuilder: (context) => const MainMenuScreen(),
          );
        }

        if (settings.name == '/game') {
          return MainMenuRouteBuilder(
            dimensionsProvider: dimensionsProvider,
            pageBuilder: (context) => GameScreen(),
          );
        }

        if (settings.name == '/leaderboard') {
          return MainMenuRouteBuilder(
            pageBuilder: (context) => LeaderboardScreen(),
          );
        }

        throw Exception("Route not found");
      },
    );
  }
}

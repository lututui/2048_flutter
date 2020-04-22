import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/types/callbacks.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.enabled = false;

  runApp(Main());
}

class Main extends StatelessWidget {
  final DimensionsProvider dimensionsProvider = DimensionsProvider();

  Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: Fonts.RIGHTEOUS_FAMILY,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MainRouteBuilder(
            dimensionsProvider: this.dimensionsProvider,
            pageBuilder: (context) => const MainMenuScreen(),
          );
        }

        if (settings.name == '/game') {
          return MainRouteBuilder(
            dimensionsProvider: this.dimensionsProvider,
            pageBuilder: (context) => GameScreen(),
          );
        }

        if (settings.name == '/leaderboard') {
          return MainRouteBuilder(
            dimensionsProvider: this.dimensionsProvider,
            pageBuilder: (context) => LeaderboardScreen(),
          );
        }

        throw Exception("Route not found");
      },
    );
  }
}

class MainRouteBuilder<T> extends PageRouteBuilder<T> {
  MainRouteBuilder({
    WidgetContextCallback pageBuilder,
    DimensionsProvider dimensionsProvider,
  }) : super(
          pageBuilder: (context, _, __) {
            return ChangeNotifierProvider.value(
              value: dimensionsProvider,
              child: Builder(
                builder: (context) {
                  DimensionsProvider.of(
                    context,
                    listen: false,
                  ).updateScreenSize(context);

                  return pageBuilder(context);
                },
              ),
            );
          },
        );
}

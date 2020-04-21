import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.enabled = false;

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: Fonts.RIGHTEOUS_FAMILY,
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return PageRouteBuilder(
            pageBuilder: (context, _, __) => const MainMenuScreen(),
          );
        }

        if (settings.name == '/game') {
          return PageRouteBuilder(
            pageBuilder: (context, _, __) => ChangeNotifierProvider(
              create: (_) => DimensionsProvider.from(
                context,
                settings.arguments as int,
              ),
              child: GameScreen(),
            ),
          );
        }

        if (settings.name == '/leaderboard') {
          return PageRouteBuilder(
            pageBuilder: (context, _, __) => ChangeNotifierProvider(
              create: (_) => DimensionsProvider.from(
                context,
                settings.arguments as int,
              ),
              child: LeaderboardScreen(),
            ),
          );
        }

        throw Exception("Route not found");
      },
    );
  }
}

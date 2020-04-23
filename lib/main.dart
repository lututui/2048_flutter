import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/grid/dummy_holder_provider.dart';
import 'package:flutter_2048/types/callbacks.dart';
import 'package:flutter_2048/util/fonts.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.enabled = false;

  runApp(Main());
}

class Main extends StatelessWidget {
  final ChangeNotifierProvider<DimensionsProvider> dimensionsProvider;
  final Provider<DummyHolderProvider> dummyHolderProvider;

  Main({Key key})
      : dummyHolderProvider = Provider<DummyHolderProvider>(
          create: (_) => DummyHolderProvider(),
        ),
        dimensionsProvider = ChangeNotifierProvider<DimensionsProvider>(
          create: (_) => DimensionsProvider(),
        ),
        super(key: key);

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
            providers: [this.dimensionsProvider, this.dummyHolderProvider],
            pageBuilder: (context) => const MainMenuScreen(),
          );
        }

        if (settings.name == '/game') {
          return MainRouteBuilder(
            providers: [this.dimensionsProvider],
            pageBuilder: (context) => GameScreen(),
          );
        }

        if (settings.name == '/leaderboard') {
          return MainRouteBuilder(
            providers: [this.dimensionsProvider],
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
    List<SingleChildWidget> providers,
  }) : super(
          pageBuilder: (context, _, __) {
            return MultiProvider(
              providers: providers,
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

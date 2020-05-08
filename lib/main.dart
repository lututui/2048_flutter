import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/route/main_menu_route_builder.dart';
import 'package:flutter_2048/types/fonts.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/util/palette.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';
import 'package:flutter_2048/widgets/screens/palette_selection_screen.dart';
import 'package:flutter_2048/widgets/screens/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SharedPreferences.getInstance().then((preferences) {
      Main.settingsProvider.darkMode = preferences.getBool('darkMode') ?? false;
      Main.settingsProvider.palette = Palette.getGamePaletteByName(
        preferences.getString('palette'),
      );
    }),
  ]);

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  static final DimensionsProvider dimensionsProvider = DimensionsProvider();
  static final SettingsProvider settingsProvider = SettingsProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: settingsProvider,
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
            theme: Misc.buildThemeDataFromColorScheme(
              Palette.lightTheme,
              fontFamily: Fonts.righteousFamily,
            ),
            darkTheme: Misc.buildThemeDataFromColorScheme(
              Palette.darkTheme,
              fontFamily: Fonts.righteousFamily,
            ),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MainMenuRouteBuilder(
                  dimensionsProvider: dimensionsProvider,
                  pageBuilder: (context) => const MainMenuScreen(),
                );
              }

              if (settings.name == '/game') {
                return MainMenuRouteBuilder(
                  dimensionsProvider: dimensionsProvider,
                  pageBuilder: (context) => const GameScreen(),
                );
              }

              if (settings.name == '/leaderboard') {
                return MainMenuRouteBuilder(
                  pageBuilder: (context) => LeaderboardScreen(),
                );
              }

              if (settings.name == '/settings') {
                return MainMenuRouteBuilder(
                  pageBuilder: (context) => const SettingsScreen(),
                );
              }

              if (settings.name == '/palette_picker') {
                return MainMenuRouteBuilder(
                  pageBuilder: (context) => const PaletteSelectionScreen(),
                );
              }

              throw Exception('Route not found: ${settings.name}');
            },
          );
        },
      ),
    );
  }
}

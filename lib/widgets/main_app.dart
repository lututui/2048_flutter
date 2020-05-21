import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/settings_provider.dart';
import 'package:flutter_2048/route/main_menu_route_builder.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/screens/game_screen.dart';
import 'package:flutter_2048/widgets/screens/leaderboard_screen.dart';
import 'package:flutter_2048/widgets/screens/main_menu_screen.dart';
import 'package:flutter_2048/widgets/screens/palette_selection_screen.dart';
import 'package:flutter_2048/widgets/screens/settings_screen.dart';
import 'package:provider/provider.dart';

/// The main app widget, loaded by [MainAppLoader]
class MainApp extends StatelessWidget {
  /// Creates a new app widget
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, _) {
        return MaterialApp(
          themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
          theme: Misc.themes[Brightness.light],
          darkTheme: Misc.themes[Brightness.dark],
          debugShowCheckedModeBanner: false,
          home: const MainMenuScreen(),
          onGenerateRoute: (settings) {
            if (settings.name == '/game') {
              return MainMenuRouteBuilder(
                pageBuilder: (context) => const GameScreen(),
              );
            }

            if (settings.name == '/leaderboard') {
              return MainMenuRouteBuilder(
                pageBuilder: (context) => const LeaderboardScreen(),
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
    );
  }
}

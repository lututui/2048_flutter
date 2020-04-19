import 'package:flutter/material.dart';
import 'package:flutter_2048/providers/dimensions_provider.dart';
import 'package:flutter_2048/widgets/main_game.dart';
import 'package:flutter_2048/widgets/main_menu.dart';
import 'package:provider/provider.dart';

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return PageRouteBuilder(
              pageBuilder: (context, _, __) => const MainMenu(),
            );
            break;
          case '/game4x4':
            return PageRouteBuilder(
              pageBuilder: (context, _, __) => ChangeNotifierProvider(
                create: (_) => DimensionsProvider.from(context, 4),
                child: MainGame(),
              ),
            );
            break;
          default:
            throw Exception("Route not found");
        }
      },
    );
  }
}

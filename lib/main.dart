import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/util/misc.dart';
import 'package:flutter_2048/widgets/main_app_loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]),
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]),
  ]);

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return MaterialApp(
      theme: Misc.themes[Brightness.light],
      darkTheme: Misc.themes[Brightness.dark],
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Text(
              details.exceptionAsString(),
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  };

  runApp(const MainAppLoader());
}

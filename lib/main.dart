import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/logger.dart';
import 'package:flutter_2048/widgets/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.enabled = false;

  runApp(const MainApp());
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/widgets/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MainApp());
}

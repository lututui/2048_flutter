import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/main_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //await flameUtil.fullScreen();
  await Flame.util.setOrientation(DeviceOrientation.portraitUp);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainMenu(),
    ),
  );
}

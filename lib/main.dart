import 'package:flame/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_2048/game_2048.dart';
import 'package:flutter_2048/gesture_recognizer/SwipeGestureRecognizer.dart';

void main() async {
  final Util flameUtil = Util();

  WidgetsFlutterBinding.ensureInitialized();

  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);

  final Game2048 game = Game2048();
  final SwipeGestureRecognizer gestureRecognizer = SwipeGestureRecognizer(
    flameUtil,
    game.onSwipe,
  );

  runApp(game.widget);
}

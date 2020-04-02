import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flutter_2048/components/game_box.dart';
import 'package:flutter_2048/gesture_recognizer/SwipeGestureRecognizer.dart';
import 'package:flutter_2048/palette.dart';

class Game2048 extends Game {
  GameBox gameBox;
  Size screenSize;

  @override
  Color backgroundColor() => Palette.paleLavender.color;

  @override
  void render(Canvas canvas) {
    gameBox?.render(canvas);
  }

  @override
  void update(double t) {
    gameBox?.update(t);
  }

  @override
  void resize(Size size) {
    this.screenSize = size;

    if (this.gameBox == null) {
      this.gameBox = GameBox(4, size);
    } else {
      this.gameBox.resize(size);
    }

    super.resize(size);
  }

  void onSwipe(SwipeGestureType type) {
    this.gameBox?.swipe(type);
  }


}

import 'dart:ui';

import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_2048/components/game_box.dart';
import 'package:flutter_2048/extensions/swipe_gesture_type.dart';
import 'package:flutter_2048/mixins/pausable.dart';
import 'package:flutter_2048/types/swipe_gesture_type.dart';
import 'package:flutter_2048/util/palette.dart';

class Game2048 extends Game
    with VerticalDragDetector, HorizontalDragDetector, IPausable {
  GameBox gameBox;
  Size screenSize;
  bool gameOver = false;
  bool gameStarted = false;
  int score = 0;

  Game2048() {
    this.gameBox = GameBox(this, 4);
  }

  @override
  Color backgroundColor() => Palette.paleLavender.color;

  @override
  void render(Canvas canvas) {
    this.gameBox.render(canvas);
  }

  @override
  void update(double t) {
    if (this.gameOver) return;

    this.gameBox.update(t);
    this.gameBox.calcGameOver();
  }

  @override
  void resize(Size size) {
    this.screenSize = size;
    this.gameBox.resize(size);

    if (!this.gameStarted) {
      this.gameBox.spawn(amount: 3);
      this.gameStarted = true;
    }

    super.resize(size);
  }

  @override
  void onHorizontalDragEnd(DragEndDetails d) {
    if (this.isPaused) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.LEFT
        : SwipeGestureType.RIGHT;

    print("Swipe ${type.toDirectionString()}");

    this.gameBox.swipe(type);
  }

  @override
  void onVerticalDragEnd(DragEndDetails d) {
    if (this.isPaused) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.UP
        : SwipeGestureType.DOWN;

    print("Swipe ${type.toDirectionString()}");

    this.gameBox.swipe(type);
  }

  void reset() {
    this.gameBox = GameBox(this, 4);

    this.unpause();
    this.gameBox.resize(this.screenSize);
    this.gameBox.spawn(amount: 3);
    this.gameOver = false;
    this.score = 0;
  }
}

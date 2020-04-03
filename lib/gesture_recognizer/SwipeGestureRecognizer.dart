import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';

enum SwipeGestureType { UP, DOWN, LEFT, RIGHT }

extension SwipeGestureTypeString on SwipeGestureType {
  String toDirectionString() {
    if (this == SwipeGestureType.UP) return "UP";

    if (this == SwipeGestureType.RIGHT) return "RIGHT";

    if (this == SwipeGestureType.LEFT) return "LEFT";

    if (this == SwipeGestureType.DOWN) return "DOWN";

    throw Exception(
      "Unknown SwipeGestureType: (${this.index}, ${this.toString()})",
    );
  }

  bool isVertical() {
    if (this == SwipeGestureType.DOWN || this == SwipeGestureType.UP)
      return true;

    if (this == SwipeGestureType.LEFT || this == SwipeGestureType.RIGHT)
      return false;

    throw Exception(
      "Unknown SwipeGestureType: (${this.index}, ${this.toString()})",
    );
  }

  bool isHorizontal() {
    return !this.isVertical();
  }

  bool towardsOrigin() {
    if (this == SwipeGestureType.LEFT || this == SwipeGestureType.UP)
      return true;

    if (this == SwipeGestureType.RIGHT || this == SwipeGestureType.DOWN)
      return false;

    throw Exception(
      "Unknown SwipeGestureType: (${this.index}, ${this.toString()})",
    );
  }

  bool awayFromOrigin() {
    return !this.towardsOrigin();
  }
}

typedef SwipeCallback = void Function(SwipeGestureType type);

class SwipeGestureRecognizer {
  HorizontalDragGestureRecognizer horizontalDrag;
  VerticalDragGestureRecognizer verticalDrag;

  SwipeCallback onSwipe;

  bool _paused;

  SwipeGestureRecognizer(this.onSwipe) {
    this.horizontalDrag = HorizontalDragGestureRecognizer();
    this.verticalDrag = VerticalDragGestureRecognizer();

    this.horizontalDrag.onEnd = this._onHorizontalEnd;
    this.verticalDrag.onEnd = this._onVerticalEnd;

    this.unpause();
  }

  void _onHorizontalEnd(DragEndDetails d) {
    if (this.onSwipe == null) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.LEFT
        : SwipeGestureType.RIGHT;

    print("Swipe ${type.toDirectionString()}");

    this.onSwipe(type);
  }

  void _onVerticalEnd(DragEndDetails d) {
    if (this.onSwipe == null) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.UP
        : SwipeGestureType.DOWN;

    print("Swipe ${type.toDirectionString()}");

    this.onSwipe(type);
  }

  void pause() {
    if (!this._paused) return;

    Flame.util.removeGestureRecognizer(this.verticalDrag);
    Flame.util.removeGestureRecognizer(this.horizontalDrag);

    this._paused = true;
  }

  void unpause() {
    if (this._paused ?? true) return;

    Flame.util.addGestureRecognizer(this.horizontalDrag);
    Flame.util.addGestureRecognizer(this.verticalDrag);

    this._paused = false;
  }
}

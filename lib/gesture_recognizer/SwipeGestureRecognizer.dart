import 'package:flame/util.dart';
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

  SwipeGestureRecognizer(Util flameUtil, this.onSwipe) {
    this.horizontalDrag = HorizontalDragGestureRecognizer();
    this.verticalDrag = VerticalDragGestureRecognizer();

    this.horizontalDrag.onEnd = this._onHorizontalEnd;
    this.verticalDrag.onEnd = this._onVerticalEnd;

    flameUtil.addGestureRecognizer(this.horizontalDrag);
    flameUtil.addGestureRecognizer(this.verticalDrag);
  }

  void _onHorizontalEnd(DragEndDetails d) {
    if (onSwipe == null) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dx < 0
        ? SwipeGestureType.LEFT
        : SwipeGestureType.RIGHT;

    print("Swipe ${type.toDirectionString()}");

    this.onSwipe(type);
  }

  void _onVerticalEnd(DragEndDetails d) {
    if (onSwipe == null) return;

    SwipeGestureType type = d.velocity.pixelsPerSecond.dy < 0
        ? SwipeGestureType.UP
        : SwipeGestureType.DOWN;

    print("Swipe ${type.toDirectionString()}");

    this.onSwipe(type);
  }
}

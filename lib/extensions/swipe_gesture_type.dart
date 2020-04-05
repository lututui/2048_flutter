import 'package:flutter_2048/types/swipe_gesture_type.dart';

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

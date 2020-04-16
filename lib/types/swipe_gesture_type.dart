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

  bool get isVertical {
    if (this == SwipeGestureType.DOWN || this == SwipeGestureType.UP)
      return true;

    if (this == SwipeGestureType.LEFT || this == SwipeGestureType.RIGHT)
      return false;

    throw Exception(
      "Unknown SwipeGestureType: (${this.index}, ${this.toString()})",
    );
  }

  bool get isHorizontal {
    return !this.isVertical;
  }

  bool get towardsOrigin {
    if (this == SwipeGestureType.LEFT || this == SwipeGestureType.UP)
      return true;

    if (this == SwipeGestureType.RIGHT || this == SwipeGestureType.DOWN)
      return false;

    throw Exception(
      "Unknown SwipeGestureType: (${this.index}, ${this.toString()})",
    );
  }

  bool get awayFromOrigin {
    return !this.towardsOrigin;
  }
}

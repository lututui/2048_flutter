enum _GestureDirection { up, down, left, right }

class SwipeGestureType {
  const SwipeGestureType._(this.type, this.directionString);

  final _GestureDirection type;
  final String directionString;

  bool get isVertical {
    return type == _GestureDirection.up || type == _GestureDirection.down;
  }

  bool get isHorizontal {
    return type == _GestureDirection.left || type == _GestureDirection.right;
  }

  bool get towardsOrigin {
    return type == _GestureDirection.up || type == _GestureDirection.left;
  }

  bool get awayFromOrigin {
    return type == _GestureDirection.down || type == _GestureDirection.right;
  }

  static const SwipeGestureType up = SwipeGestureType._(
    _GestureDirection.up,
    'UP',
  );

  static const SwipeGestureType down = SwipeGestureType._(
    _GestureDirection.down,
    'DOWN',
  );

  static const SwipeGestureType left = SwipeGestureType._(
    _GestureDirection.left,
    'LEFT',
  );

  static const SwipeGestureType right = SwipeGestureType._(
    _GestureDirection.right,
    'RIGHT',
  );
}

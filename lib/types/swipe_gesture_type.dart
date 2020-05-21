enum _GestureDirection { up, down, left, right }

/// A swipe gesture is either a horizontal or vertical drag gesture
class SwipeGestureType {
  const SwipeGestureType._(this._type, this._directionString);

  final _GestureDirection _type;
  final String _directionString;

  /// Whether this is a vertical drag
  bool get isVertical {
    return _type == _GestureDirection.up || _type == _GestureDirection.down;
  }

  /// Whether this is a horizontal drag
  bool get isHorizontal {
    return _type == _GestureDirection.left || _type == _GestureDirection.right;
  }

  /// Whether the direction of this gesture goes towards its origin point
  ///
  /// The origin point is the top left corner of the screen.
  bool get towardsOrigin {
    return _type == _GestureDirection.up || _type == _GestureDirection.left;
  }

  /// Whether the direction of this gesture goes away from its origin point
  ///
  /// The origin point is the top left corner of the screen.
  bool get awayFromOrigin {
    return _type == _GestureDirection.down || _type == _GestureDirection.right;
  }

  /// The vertical drag up gesture
  static const SwipeGestureType up = SwipeGestureType._(
    _GestureDirection.up,
    'UP',
  );

  /// The vertical drag down gesture
  static const SwipeGestureType down = SwipeGestureType._(
    _GestureDirection.down,
    'DOWN',
  );

  /// The horizontal drag left gesture
  static const SwipeGestureType left = SwipeGestureType._(
    _GestureDirection.left,
    'LEFT',
  );

  /// The horizontal drag right gesture
  static const SwipeGestureType right = SwipeGestureType._(
    _GestureDirection.right,
    'RIGHT',
  );

  @override
  String toString() => _directionString;
}

import 'dart:ui';

/// A pair of values
class Tuple<T, E> {
  /// Creates a new pair of values
  const Tuple(this.a, this.b);

  /// Creates a copy of the pair o values
  factory Tuple.copy(Tuple<T, E> other) {
    return Tuple(other.a, other.b);
  }

  /// The first value
  final T a;

  /// The second value
  final E b;

  @override
  int get hashCode => hashValues(a, b);

  @override
  bool operator ==(Object other) {
    return other is Tuple<T, E> && other.a == a && other.b == b;
  }

  @override
  String toString() => '($a, $b)';
}

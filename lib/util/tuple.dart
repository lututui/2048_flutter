import 'dart:ui';

class Tuple<T, E> {
  T a;
  E b;

  Tuple(this.a, this.b);

  factory Tuple.copy(Tuple other) {
    return Tuple<T, E>(other.a, other.b);
  }

  @override
  bool operator ==(other) {
    return other is Tuple<T, E> && other.a == this.a && other.b == this.b;
  }

  @override
  int get hashCode => hashValues(this.a, this.b);

  void set(T a, E b) {
    this.a = a;
    this.b = b;
  }

  @override
  String toString() => "($a, $b)";
}

class ImmutableTuple<T, E> {
  final T a;
  final E b;

  const ImmutableTuple(this.a, this.b);

  factory ImmutableTuple.copy(ImmutableTuple other) {
    return ImmutableTuple<T, E>(other.a, other.b);
  }

  factory ImmutableTuple.fromMutable(Tuple other) {
    return ImmutableTuple<T, E>(other.a, other.b);
  }

  @override
  bool operator ==(other) {
    return other is Tuple<T, E> && other.a == this.a && other.b == this.b;
  }

  @override
  int get hashCode => hashValues(this.a, this.b);

  @override
  String toString() => "($a, $b)";
}

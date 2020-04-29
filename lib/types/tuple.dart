import 'dart:ui';

abstract class Tuple<T, E> {
  T get a;

  E get b;

  bool get isImmutable;

  Tuple._();

  factory Tuple(T a, E b) => _ImmutableTuple(a, b);

  factory Tuple.mutable(T a, E b) => _MutableTuple(a, b);

  factory Tuple.copy(Tuple other) => other.isImmutable
      ? _ImmutableTuple.copy(other)
      : _MutableTuple.copy(other);

  @override
  int get hashCode => hashValues(this.a, this.b);

  @override
  bool operator ==(other) {
    return other is Tuple<T, E> && other.a == this.a && other.b == this.b;
  }

  @override
  String toString() => "($a, $b)";
}

class _MutableTuple<T, E> extends Tuple<T, E> {
  @override
  T a;
  @override
  E b;

  _MutableTuple(this.a, this.b) : super._();

  factory _MutableTuple.copy(Tuple other) {
    return _MutableTuple<T, E>(other.a, other.b);
  }

  void set(T a, E b) {
    this.a = a;
    this.b = b;
  }

  @override
  bool get isImmutable => false;
}

class _ImmutableTuple<T, E> extends Tuple<T, E> {
  @override
  final T a;
  @override
  final E b;

  _ImmutableTuple(this.a, this.b) : super._();

  factory _ImmutableTuple.copy(_ImmutableTuple other) {
    return _ImmutableTuple<T, E>(other.a, other.b);
  }

  @override
  bool get isImmutable => true;
}

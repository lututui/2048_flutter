import 'dart:ui';

abstract class Tuple<T, E> {
  factory Tuple(T a, E b) => _ImmutableTuple(a, b);

  Tuple._();

  factory Tuple.mutable(T a, E b) => _MutableTuple(a, b);

  factory Tuple.copy(Tuple<T, E> other) => other.isImmutable
      ? _ImmutableTuple.copy(other)
      : _MutableTuple.copy(other);

  T get a;

  E get b;

  bool get isImmutable;

  @override
  int get hashCode => hashValues(a, b);

  @override
  bool operator ==(Object other) {
    return other is Tuple<T, E> && other.a == a && other.b == b;
  }

  @override
  String toString() => '($a, $b)';
}

class _MutableTuple<T, E> extends Tuple<T, E> {
  _MutableTuple(this.a, this.b) : super._();

  factory _MutableTuple.copy(Tuple<T, E> other) {
    return _MutableTuple<T, E>(other.a, other.b);
  }

  @override
  T a;
  @override
  E b;

  void set(T a, E b) {
    this.a = a;
    this.b = b;
  }

  @override
  bool get isImmutable => false;
}

class _ImmutableTuple<T, E> extends Tuple<T, E> {
  _ImmutableTuple(this.a, this.b) : super._();

  factory _ImmutableTuple.copy(Tuple<T, E> other) {
    return _ImmutableTuple<T, E>(other.a, other.b);
  }

  @override
  final T a;
  @override
  final E b;

  @override
  bool get isImmutable => true;
}

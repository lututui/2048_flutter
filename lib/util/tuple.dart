import 'package:quiver/core.dart';

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
  int get hashCode => hash2(this.a, this.b);

  void set(T a, E b) {
    this.a = a;
    this.b = b;
  }

  @override
  String toString() => "($a, $b)";
}

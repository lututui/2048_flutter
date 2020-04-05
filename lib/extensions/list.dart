extension ListEquality<T> on List<T> {
  bool equalContents<E>(List<E> other) {
    if (this.length != other.length) return false;

    if (T != E) return false;

    for (int i = 0; i < this.length; i++) if (this[i] != other[i]) return false;

    return true;
  }
}

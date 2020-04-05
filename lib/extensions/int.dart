extension IntShift on int {
  num safeLShift(int shiftAmount) {
    if (shiftAmount == -1) return 1;

    if (shiftAmount < 0)
      return 1.0 / this.safeLShift(-shiftAmount);

    return this << shiftAmount;
  }
}
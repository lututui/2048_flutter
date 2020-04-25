class Lists {
  const Lists._();

  static num takeAverage(List<num> list) {
    if (list == null || list.isEmpty)
      throw Exception("Cannot take average of empty list");

    return list.reduce((value, element) => value += element) / list.length;
  }
}
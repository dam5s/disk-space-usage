extension Flatten<T> on List<List<T>> {
  List<T> flatten() {
    final result = <T>[];
    for (final list in this) {
      result.addAll(list);
    }
    return result;
  }
}

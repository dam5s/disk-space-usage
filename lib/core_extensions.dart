
extension TryMap<T> on Iterable<T> {

  Iterable<U> tryMap<U>(U? Function(T) mapping) =>
    expand((element) {
      final mapped = mapping(element);

      if (mapped == null) {
        return [];
      }

      return [mapped];
    });
}

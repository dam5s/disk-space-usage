extension IterableExtensions<T> on Iterable<T> {
  Iterable<U> tryMap<U>(U? Function(T) mapping) => expand((element) {
        final mapped = mapping(element);

        if (mapped == null) {
          return [];
        }

        return [mapped];
      });

  Iterable<T> filter(bool Function(T) predicate) => expand((element) {
        if (predicate(element)) {
          return [element];
        }
        return [];
      });
}

extension IterableOfOptionalExtensions<T> on Iterable<T?> {

  Iterable<T> flatten() => filter((e) => e != null).cast<T>();
}

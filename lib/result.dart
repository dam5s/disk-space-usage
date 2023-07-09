sealed class Result<T, E> {}

class Ok<T, E> implements Result<T, E> {
  final T value;

  const Ok(this.value);
}

class Err<T, E> implements Result<T, E> {
  final E error;

  const Err(this.error);
}

extension ResultFunctions<T, E> on Result<T, E> {
  Result<NewT, E> mapOk<NewT>(NewT Function(T) mapping) =>
      switch (this) {
        Ok(value: final v) => Ok(mapping(v)),
        Err(error: final e) => Err(e),
      };

  Result<NewT, E> flatMapOk<NewT>(Result<NewT, E> Function(T) mapping) =>
      switch (this) {
        Ok(value: final v) => mapping(v),
        Err(error: final e) => Err(e),
      };

  Result<T, NewE> mapErr<NewE>(NewE Function(E) mapping) =>
      switch (this) {
        Ok(value: final v) => Ok(v),
        Err(error: final e) => Err(mapping(e)),
      };

  T orElse(T Function(E) mapping) =>
      switch (this) {
        Ok(value: final v) => v,
        Err(error: final e) => mapping(e),
      };
}

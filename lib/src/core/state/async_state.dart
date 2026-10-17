sealed class AsyncState<T> {
  const AsyncState();

  bool get isLoading => this is AsyncLoading<T>;
  bool get hasData => this is AsyncData<T>;
  bool get hasError => this is AsyncError<T>;
}

final class AsyncLoading<T> extends AsyncState<T> {
  const AsyncLoading();
}

final class AsyncData<T> extends AsyncState<T> {
  const AsyncData(this.value);

  final T value;
}

final class AsyncError<T> extends AsyncState<T> {
  const AsyncError(this.error, {this.stackTrace});

  final Object error;
  final StackTrace? stackTrace;
}

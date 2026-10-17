import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/core/state/async_state.dart';

void main() {
  test('represents loading, data, and error states', () {
    const loading = AsyncLoading<int>();
    const data = AsyncData(42);
    final exception = Exception('failed');
    final error = AsyncError<int>(exception);

    expect(loading.isLoading, isTrue);
    expect(data.hasData, isTrue);
    expect(data.value, 42);
    expect(error.hasError, isTrue);
    expect(error.error, same(exception));
  });
}

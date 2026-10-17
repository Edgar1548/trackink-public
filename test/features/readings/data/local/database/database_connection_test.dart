import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/data/local/database/database_connection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('creates the platform database executor lazily', () {
    final executor = openTrackInkDatabase();

    expect(executor, isA<QueryExecutor>());
  });
}

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

const trackInkDatabaseName = 'trackink';

QueryExecutor openTrackInkDatabase() {
  return driftDatabase(name: trackInkDatabaseName);
}

import 'package:drift/drift.dart';

import 'database_connection.dart';
import 'reading_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Readings, Tags, ReadingTags])
final class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  AppDatabase.defaults() : super(openTrackInkDatabase());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}

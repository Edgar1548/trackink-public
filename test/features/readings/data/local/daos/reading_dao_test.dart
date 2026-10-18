import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/data/local/daos/reading_dao.dart';
import 'package:trackink/src/features/readings/data/local/database/app_database.dart';

void main() {
  late AppDatabase database;
  late ReadingDao dao;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    dao = ReadingDao(database);
  });

  tearDown(() => database.close());

  test('returns the limited first page ordered by latest update', () async {
    final oldest = DateTime.utc(2026, 1, 1);
    final latest = DateTime.utc(2026, 1, 3);

    await _insertReading(database, id: 'oldest', updatedAt: oldest);
    await _insertReading(database, id: 'latest-b', updatedAt: latest);
    await _insertReading(database, id: 'latest-a', updatedAt: latest);

    final tagId = await database.into(database.tags).insert(
      TagsCompanion.insert(name: 'Drama'),
    );
    await database.into(database.readingTags).insert(
      ReadingTagsCompanion.insert(readingId: 'latest-a', tagId: tagId),
    );

    final page = await dao.getFirstPage(limit: 2);

    expect(
      page.map((item) => item.reading.id),
      orderedEquals(['latest-a', 'latest-b']),
    );
    expect(page.first.tags.map((tag) => tag.name), ['Drama']);
  });

  test('rejects a non-positive page limit', () async {
    await expectLater(dao.getFirstPage(limit: 0), throwsArgumentError);
  });
}

Future<void> _insertReading(
  AppDatabase database, {
  required String id,
  required DateTime updatedAt,
}) async {
  await database.into(database.readings).insert(
    ReadingsCompanion.insert(
      id: id,
      title: id,
      type: 'manga',
      status: 'inProgress',
      alternativeTitles: const Value('[]'),
      createdAt: updatedAt,
      updatedAt: updatedAt,
    ),
  );
}

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/data/local/daos/reading_dao.dart';
import 'package:trackink/src/features/readings/data/local/database/app_database.dart';
import 'package:trackink/src/features/readings/data/repositories/local_reading_repository.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_draft.dart';

void main() {
  late AppDatabase database;
  late LocalReadingRepository repository;
  final timestamp = DateTime.utc(2026, 1, 2);

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = LocalReadingRepository(
      ReadingDao(database),
      idGenerator: () => 'reading-1',
      currentTime: () => timestamp,
    );
  });

  tearDown(() => database.close());

  test('creates and retrieves a reading with normalized tags', () async {
    const draft = ReadingDraft(
      title: 'Title',
      author: 'Author',
      type: ReadingType.manga,
      status: ReadingStatus.completed,
      progress: 12,
      score: 4.5,
      tags: ['Drama', ' Drama ', ''],
      description: 'Description',
      alternativeTitles: ['Alternative'],
    );

    final created = await repository.create(draft);
    final stored = (await repository.getFirstPage(limit: 20)).single;
    final stats = await repository.getStats();

    expect(created.id, 'reading-1');
    expect(created.createdAt, timestamp);
    expect(created.updatedAt, timestamp);
    expect(created.tags, ['Drama']);
    expect(stored.id, created.id);
    expect(stored.tags, ['Drama']);
    expect(stored.alternativeTitles, ['Alternative']);
    expect(stats.totalReadings, 1);
    expect(stats.completedReadings, 1);
    expect(stats.totalProgress, 12);
  });
}

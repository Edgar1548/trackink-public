import 'package:drift/drift.dart';

import '../database/app_database.dart';

class ReadingWithTags {
  const ReadingWithTags({required this.reading, required this.tags});

  final ReadingRow reading;
  final List<TagRow> tags;
}

class ReadingStatsRow {
  const ReadingStatsRow({
    required this.totalReadings,
    required this.completedReadings,
    required this.totalProgress,
  });

  final int totalReadings;
  final int completedReadings;
  final int totalProgress;
}

class ReadingDao extends DatabaseAccessor<AppDatabase> {
  ReadingDao(super.attachedDatabase);

  Future<ReadingStatsRow> getStats() async {
    final result = await customSelect(
      '''
        SELECT
          COUNT(*) AS total_readings,
          COALESCE(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END), 0)
            AS completed_readings,
          COALESCE(SUM(progress), 0) AS total_progress
        FROM readings
      ''',
      readsFrom: {attachedDatabase.readings},
    ).getSingle();

    return ReadingStatsRow(
      totalReadings: result.read<int>('total_readings'),
      completedReadings: result.read<int>('completed_readings'),
      totalProgress: result.read<int>('total_progress'),
    );
  }

  Future<List<ReadingWithTags>> getFirstPage({required int limit}) async {
    if (limit <= 0) {
      throw ArgumentError.value(limit, 'limit', 'Must be greater than zero');
    }

    final readingRows = await (select(attachedDatabase.readings)
          ..orderBy([
            (reading) => OrderingTerm.desc(reading.updatedAt),
            (reading) => OrderingTerm.asc(reading.id),
          ])
          ..limit(limit))
        .get();

    if (readingRows.isEmpty) return const [];

    final tagsByReadingId = await _loadTagsByReadingId(
      readingRows.map((reading) => reading.id),
    );

    return [
      for (final reading in readingRows)
        ReadingWithTags(
          reading: reading,
          tags: tagsByReadingId[reading.id] ?? const [],
        ),
    ];
  }

  Future<Map<String, List<TagRow>>> _loadTagsByReadingId(
    Iterable<String> readingIds,
  ) async {
    final query = select(attachedDatabase.readingTags).join([
      innerJoin(
        attachedDatabase.tags,
        attachedDatabase.tags.id.equalsExp(attachedDatabase.readingTags.tagId),
      ),
    ])..where(attachedDatabase.readingTags.readingId.isIn(readingIds));

    final rows = await query.get();
    final tagsByReadingId = <String, List<TagRow>>{};

    for (final row in rows) {
      final readingId = row.readTable(attachedDatabase.readingTags).readingId;
      final tag = row.readTable(attachedDatabase.tags);
      tagsByReadingId.putIfAbsent(readingId, () => []).add(tag);
    }

    return tagsByReadingId;
  }
}

import 'dart:math';

import '../../domain/entities/reading.dart';
import '../../domain/entities/reading_draft.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/repositories/reading_creator.dart';
import '../../domain/repositories/reading_repository.dart';
import '../local/daos/reading_dao.dart';
import '../local/mappers/reading_mapper.dart';

typedef ReadingIdGenerator = String Function();
typedef CurrentTime = DateTime Function();

final class LocalReadingRepository implements ReadingRepository, ReadingCreator {
  LocalReadingRepository(
    this._dao, {
    ReadingIdGenerator? idGenerator,
    CurrentTime? currentTime,
  }) : _idGenerator = idGenerator ?? _generateReadingId,
       _currentTime = currentTime ?? DateTime.now;

  final ReadingDao _dao;
  final ReadingIdGenerator _idGenerator;
  final CurrentTime _currentTime;

  @override
  Future<Reading> create(ReadingDraft draft) async {
    final now = _currentTime();
    final normalizedTags = draft.tags
        .map((tag) => tag.trim())
        .where((tag) => tag.isNotEmpty)
        .toSet()
        .toList(growable: false);
    final reading = Reading(
      id: _idGenerator(),
      title: draft.title,
      author: draft.author,
      type: draft.type,
      status: draft.status,
      progress: draft.progress,
      score: draft.score,
      tags: normalizedTags,
      description: draft.description,
      alternativeTitles: List.unmodifiable(draft.alternativeTitles),
      createdAt: now,
      updatedAt: now,
    );

    await _dao.insertReading(
      reading: mapReadingToCompanion(reading),
      tagNames: reading.tags,
    );
    return reading;
  }

  @override
  Future<ReadingStats> getStats() async {
    final row = await _dao.getStats();
    return ReadingStats(
      totalReadings: row.totalReadings,
      completedReadings: row.completedReadings,
      totalProgress: row.totalProgress,
    );
  }

  @override
  Future<List<Reading>> getFirstPage({required int limit}) async {
    final rows = await _dao.getFirstPage(limit: limit);
    return _mapRows(rows);
  }

  @override
  Future<List<Reading>> getNextPage({
    required int limit,
    required int offset,
  }) async {
    final rows = await _dao.getNextPage(limit: limit, offset: offset);
    return _mapRows(rows);
  }

  List<Reading> _mapRows(List<ReadingWithTags> rows) {
    return rows
        .map(
          (result) => mapReadingRowToDomain(result.reading, result.tags),
        )
        .toList(growable: false);
  }
}

String _generateReadingId() {
  final timestamp = DateTime.now().microsecondsSinceEpoch.toRadixString(36);
  final random = Random.secure().nextInt(1 << 32).toRadixString(36);
  return '$timestamp-$random';
}

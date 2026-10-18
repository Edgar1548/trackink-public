import '../../domain/entities/reading.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/repositories/reading_repository.dart';
import '../local/daos/reading_dao.dart';
import '../local/mappers/reading_mapper.dart';

final class LocalReadingRepository implements ReadingRepository {
  const LocalReadingRepository(this._dao);

  final ReadingDao _dao;

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

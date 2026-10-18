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

    return rows
        .map(
          (result) => mapReadingRowToDomain(result.reading, result.tags),
        )
        .toList(growable: false);
  }
}

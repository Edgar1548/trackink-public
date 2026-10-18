import '../../domain/entities/reading.dart';
import '../../domain/repositories/reading_repository.dart';
import '../local/daos/reading_dao.dart';
import '../local/mappers/reading_mapper.dart';

final class LocalReadingRepository implements ReadingRepository {
  const LocalReadingRepository(this._dao);

  final ReadingDao _dao;

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

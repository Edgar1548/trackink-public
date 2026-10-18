import '../entities/reading.dart';
import '../entities/reading_stats.dart';

abstract interface class ReadingRepository {
  Future<List<Reading>> getFirstPage({required int limit});

  Future<List<Reading>> getNextPage({required int limit, required int offset});

  Future<ReadingStats> getStats();
}

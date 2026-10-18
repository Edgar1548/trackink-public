import '../entities/reading.dart';
import '../entities/reading_stats.dart';

abstract interface class ReadingRepository {
  Future<List<Reading>> getFirstPage({required int limit});

  Future<ReadingStats> getStats();
}

import '../entities/reading.dart';

abstract interface class ReadingRepository {
  Future<List<Reading>> getFirstPage({required int limit});
}

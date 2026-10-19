import '../entities/reading.dart';
import '../entities/reading_draft.dart';

abstract interface class ReadingCreator {
  Future<Reading> create(ReadingDraft draft);
}

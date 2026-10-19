import '../entities/reading.dart';
import '../entities/reading_draft.dart';
import '../repositories/reading_creator.dart';

final class CreateReading {
  const CreateReading(this._creator);

  final ReadingCreator _creator;

  Future<Reading> call(ReadingDraft draft) => _creator.create(draft);
}

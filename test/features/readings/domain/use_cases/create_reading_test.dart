import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_draft.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_creator.dart';
import 'package:trackink/src/features/readings/domain/use_cases/create_reading.dart';

void main() {
  test('delegates the draft to the reading creator', () async {
    final creator = _FakeReadingCreator();
    final useCase = CreateReading(creator);
    const draft = ReadingDraft(
      title: 'Title',
      author: 'Author',
      type: ReadingType.manga,
      status: ReadingStatus.inProgress,
      progress: 0,
      score: null,
      tags: [],
      description: '',
      alternativeTitles: [],
    );

    final created = await useCase(draft);

    expect(creator.receivedDraft, same(draft));
    expect(created.title, draft.title);
  });
}

final class _FakeReadingCreator implements ReadingCreator {
  ReadingDraft? receivedDraft;

  @override
  Future<Reading> create(ReadingDraft draft) async {
    receivedDraft = draft;
    final now = DateTime.utc(2026, 1, 1);
    return Reading(
      id: 'reading-1',
      title: draft.title,
      author: draft.author,
      type: draft.type,
      status: draft.status,
      progress: draft.progress,
      score: draft.score,
      tags: draft.tags,
      description: draft.description,
      alternativeTitles: draft.alternativeTitles,
      createdAt: now,
      updatedAt: now,
    );
  }
}

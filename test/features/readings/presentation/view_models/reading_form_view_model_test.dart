import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_draft.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_creator.dart';
import 'package:trackink/src/features/readings/domain/use_cases/create_reading.dart';
import 'package:trackink/src/features/readings/presentation/view_models/reading_form_view_model.dart';
import 'package:trackink/src/shared/text/app_strings.dart';
import 'dart:async';

void main() {
  test('starts with the defaults for a new reading', () {
    final viewModel = ReadingFormViewModel();
    addTearDown(viewModel.dispose);

    expect(viewModel.titleController.text, isEmpty);
    expect(viewModel.authorController.text, isEmpty);
    expect(viewModel.progressController.text, isEmpty);
    expect(viewModel.type, ReadingType.manga);
    expect(viewModel.status, ReadingStatus.inProgress);
    expect(viewModel.score, isNull);
  });

  test('updates selectable values and notifies listeners', () {
    final viewModel = ReadingFormViewModel();
    addTearDown(viewModel.dispose);
    var notifications = 0;
    viewModel.addListener(() => notifications++);

    viewModel.setType(ReadingType.book);
    viewModel.setStatus(ReadingStatus.completed);
    viewModel.setScore(4.5);

    expect(viewModel.type, ReadingType.book);
    expect(viewModel.status, ReadingStatus.completed);
    expect(viewModel.score, 4.5);
    expect(notifications, 3);
  });

  test('validates required and numeric form values', () {
    final viewModel = ReadingFormViewModel();
    addTearDown(viewModel.dispose);

    expect(viewModel.validateRequired('  '), AppStrings.requiredField);
    expect(viewModel.validateRequired('Title'), isNull);
    expect(viewModel.validateProgress(''), isNull);
    expect(viewModel.validateProgress('12'), isNull);
    expect(viewModel.validateProgress('-1'), AppStrings.invalidNumber);
    expect(viewModel.validateProgress('unknown'), AppStrings.invalidNumber);
  });

  test('creates a reading draft from the form values', () async {
    final creator = _FakeReadingCreator();
    final viewModel = ReadingFormViewModel(CreateReading(creator));
    addTearDown(viewModel.dispose);
    viewModel.titleController.text = '  Title  ';
    viewModel.authorController.text = '  Author  ';
    viewModel.progressController.text = '12';
    viewModel.tagsController.text = 'action, fantasy, action';
    viewModel.descriptionController.text = '  Description  ';
    viewModel.alternativeTitlesController.text = 'Alt one, Alt two';
    viewModel.setType(ReadingType.book);
    viewModel.setStatus(ReadingStatus.completed);
    viewModel.setScore(4.5);

    await viewModel.save();

    final draft = creator.receivedDraft!;
    expect(draft.title, 'Title');
    expect(draft.author, 'Author');
    expect(draft.progress, 12);
    expect(draft.tags, ['action', 'fantasy', 'action']);
    expect(draft.alternativeTitles, ['Alt one', 'Alt two']);
    expect(draft.type, ReadingType.book);
    expect(draft.status, ReadingStatus.completed);
    expect(draft.score, 4.5);
  });

  test('blocks concurrent saves until creation finishes', () async {
    final creator = _PendingReadingCreator();
    final viewModel = ReadingFormViewModel(CreateReading(creator));
    addTearDown(viewModel.dispose);

    final firstSave = viewModel.save();

    expect(viewModel.isSaving, isTrue);
    expect(await viewModel.save(), isNull);
    expect(creator.calls, 1);

    creator.complete();
    await firstSave;

    expect(viewModel.isSaving, isFalse);
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


final class _PendingReadingCreator implements ReadingCreator {
  final request = Completer<Reading>();
  int calls = 0;

  @override
  Future<Reading> create(ReadingDraft draft) {
    calls++;
    return request.future;
  }

  void complete() {
    final now = DateTime.utc(2026, 1, 1);
    request.complete(
      Reading(
        id: 'reading-1',
        title: '',
        author: '',
        type: ReadingType.manga,
        status: ReadingStatus.inProgress,
        progress: 0,
        tags: const [],
        description: '',
        alternativeTitles: const [],
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}

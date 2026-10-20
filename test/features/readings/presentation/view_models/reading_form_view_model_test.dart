import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/presentation/view_models/reading_form_view_model.dart';

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
}

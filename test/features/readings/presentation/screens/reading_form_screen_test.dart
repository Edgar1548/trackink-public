import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_draft.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_creator.dart';
import 'package:trackink/src/features/readings/domain/use_cases/create_reading.dart';
import 'package:trackink/src/features/readings/presentation/screens/reading_form_screen.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('prevents submission when required fields are empty', (
    tester,
  ) async {
    final creator = _PendingReadingCreator();

    await tester.pumpWidget(
      MaterialApp(
        home: ReadingFormScreen(createReading: CreateReading(creator)),
      ),
    );

    await tester.ensureVisible(find.byKey(ReadingFormScreen.saveButtonKey));
    await tester.tap(find.byKey(ReadingFormScreen.saveButtonKey));
    await tester.pump();

    expect(find.text(AppStrings.requiredField), findsNWidgets(2));
    expect(creator.calls, 0);
  });

  testWidgets('disables submission while saving and recovers after an error', (
    tester,
  ) async {
    final creator = _PendingReadingCreator();

    await tester.pumpWidget(
      MaterialApp(
        home: ReadingFormScreen(createReading: CreateReading(creator)),
      ),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Title');
    await tester.enterText(find.byType(TextFormField).at(1), 'Author');

    await tester.ensureVisible(find.byKey(ReadingFormScreen.saveButtonKey));
    await tester.tap(find.byKey(ReadingFormScreen.saveButtonKey));
    await tester.pump();

    var button = tester.widget<FilledButton>(
      find.byKey(ReadingFormScreen.saveButtonKey),
    );
    expect(button.onPressed, isNull);
    expect(find.text(AppStrings.savingReading), findsOneWidget);
    expect(creator.calls, 1);

    creator.request.completeError(Exception('failed'));
    await tester.pumpAndSettle();

    button = tester.widget<FilledButton>(
      find.byKey(ReadingFormScreen.saveButtonKey),
    );
    expect(button.onPressed, isNotNull);
    expect(find.text(AppStrings.createReadingError), findsOneWidget);
  });
}

final class _PendingReadingCreator implements ReadingCreator {
  final request = Completer<Reading>();
  int calls = 0;

  @override
  Future<Reading> create(ReadingDraft draft) {
    calls++;
    return request.future;
  }
}

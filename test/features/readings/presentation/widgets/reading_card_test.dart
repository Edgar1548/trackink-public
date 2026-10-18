import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/presentation/widgets/reading_card.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('shows reading information and handles taps', (tester) async {
    var tapCount = 0;
    final timestamp = DateTime.utc(2026, 1, 1);
    final reading = Reading(
      id: 'reading-1',
      title: 'A title',
      author: 'An author',
      type: ReadingType.manga,
      status: ReadingStatus.inProgress,
      progress: 25,
      score: null,
      tags: const ['Drama', 'Action'],
      description: '',
      alternativeTitles: const [],
      createdAt: timestamp,
      updatedAt: timestamp,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ReadingCard(reading: reading, onTap: () => tapCount++),
        ),
      ),
    );

    expect(find.text('A title'), findsOneWidget);
    expect(find.text('An author'), findsOneWidget);
    expect(find.text('25'), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
    expect(find.text(AppStrings.statusInProgress), findsOneWidget);

    await tester.tap(find.byType(ReadingCard));
    expect(tapCount, 1);
  });
}

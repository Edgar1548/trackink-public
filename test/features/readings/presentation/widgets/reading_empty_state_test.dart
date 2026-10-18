import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/presentation/widgets/reading_empty_state.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('shows guidance when there are no readings', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ReadingEmptyState())),
    );

    expect(find.byIcon(Icons.auto_stories_outlined), findsOneWidget);
    expect(find.text(AppStrings.emptyReadingsTitle), findsOneWidget);
    expect(find.text(AppStrings.emptyReadingsMessage), findsOneWidget);
  });
}

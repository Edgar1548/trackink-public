import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/widgets/app_score_selector.dart';

void main() {
  testWidgets('reports half-star values and clears the selected value', (
    tester,
  ) async {
    double? score;

    Future<void> buildSelector(double? value) {
      return tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppScoreSelector(
              value: value,
              onChanged: (newValue) => score = newValue,
            ),
          ),
        ),
      );
    }

    await buildSelector(null);
    await tester.tap(find.byKey(const Key('score-star-4-half')));

    expect(score, 3.5);

    await buildSelector(3.5);
    await tester.tap(find.byKey(const Key('score-star-4-half')));

    expect(score, isNull);
  });
}

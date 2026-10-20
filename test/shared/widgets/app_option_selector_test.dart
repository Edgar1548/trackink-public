import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/widgets/app_option_selector.dart';

void main() {
  testWidgets('shows options and reports the selected value', (tester) async {
    var selected = 1;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppOptionSelector<int>(
            value: selected,
            options: const [
              AppOption(label: 'One', value: 1),
              AppOption(label: 'Two', value: 2),
            ],
            onChanged: (value) => selected = value,
          ),
        ),
      ),
    );

    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, 'One')).selected,
      isTrue,
    );

    await tester.tap(find.text('Two'));

    expect(selected, 2);
  });
}

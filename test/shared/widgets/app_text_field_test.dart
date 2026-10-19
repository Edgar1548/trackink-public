import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/widgets/app_text_field.dart';

void main() {
  testWidgets('writes text through the provided controller', (tester) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppTextField(controller: controller, label: 'Title'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextFormField), 'A title');

    expect(controller.text, 'A title');
    expect(find.text('Title'), findsOneWidget);
  });
}

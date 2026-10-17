import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/text/app_strings.dart';
import 'package:trackink/src/shared/widgets/app_loading_indicator.dart';

void main() {
  testWidgets('shows a sized progress indicator with a semantic label', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppLoadingIndicator(size: 32, strokeWidth: 3)),
      ),
    );

    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );

    expect(find.bySemanticsLabel(AppStrings.loading), findsOneWidget);
    expect(progress.strokeWidth, 3);
    expect(
      tester.getSize(find.byType(CircularProgressIndicator)),
      const Size.square(32),
    );
  });
}

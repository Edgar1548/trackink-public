import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/text/app_strings.dart';
import 'package:trackink/src/shared/widgets/app_error_view.dart';

void main() {
  testWidgets('shows the error and invokes retry', (tester) async {
    var retryCount = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppErrorView(
            message: AppStrings.loadReadingsError,
            onRetry: () => retryCount++,
          ),
        ),
      ),
    );

    expect(find.text(AppStrings.loadReadingsError), findsOneWidget);

    await tester.tap(find.text(AppStrings.retry));

    expect(retryCount, 1);
  });
}

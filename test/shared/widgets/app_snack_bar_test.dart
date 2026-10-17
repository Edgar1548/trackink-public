import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/shared/theme/app_tokens.dart';
import 'package:trackink/src/shared/widgets/app_snack_bar.dart';

void main() {
  test('creates success, warning, and error variants', () {
    final success = appSnackBar(title: 'Saved', message: 'Reading saved.');
    final warning = appSnackBar(
      title: 'Warning',
      message: 'Check the values.',
      type: AppSnackBarType.warning,
    );
    final error = appSnackBar(
      title: 'Error',
      message: 'Could not save.',
      type: AppSnackBarType.error,
    );

    expect(success.backgroundColor, AppPalette.successSubtle);
    expect(warning.backgroundColor, AppPalette.warningSubtle);
    expect(error.backgroundColor, AppPalette.dangerSubtle);
    expect(success.content, isA<Column>());
  });
}

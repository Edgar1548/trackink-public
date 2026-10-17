import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/main.dart';
import 'package:trackink/src/shared/theme/app_tokens.dart';

void main() {
  testWidgets('boots TrackInk', (tester) async {
    await tester.pumpWidget(const TrackInkApp());

    expect(find.text('TrackInk'), findsOneWidget);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).theme?.fontFamily,
      AppFonts.sans,
    );
    expect(
      tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor,
      null,
    );
    expect(
      Theme.of(tester.element(find.byType(Scaffold))).scaffoldBackgroundColor,
      AppPalette.cream,
    );
  });
}

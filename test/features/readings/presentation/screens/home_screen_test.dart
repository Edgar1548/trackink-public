import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/presentation/screens/home_screen.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('provides the visual structure for the reading list', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byKey(HomeScreen.contentKey), findsOneWidget);
  });
}

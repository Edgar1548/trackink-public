import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_stats.dart';
import 'package:trackink/src/features/readings/presentation/widgets/reading_stats_summary.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('shows each reading statistic', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ReadingStatsSummary(
            stats: ReadingStats(
              totalReadings: 12,
              completedReadings: 4,
              totalProgress: 80,
            ),
          ),
        ),
      ),
    );

    expect(find.text('12'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('80'), findsOneWidget);
    expect(find.text(AppStrings.totalReadings), findsOneWidget);
    expect(find.text(AppStrings.completedReadings), findsOneWidget);
    expect(find.text(AppStrings.totalProgress), findsOneWidget);
  });
}

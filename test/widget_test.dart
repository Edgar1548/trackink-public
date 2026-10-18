import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/main.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_stats.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_repository.dart';
import 'package:trackink/src/features/readings/presentation/view_models/home_view_model.dart';
import 'package:trackink/src/shared/theme/app_tokens.dart';

void main() {
  testWidgets('boots TrackInk', (tester) async {
    final viewModel = HomeViewModel(_EmptyReadingRepository());
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(TrackInkApp(homeViewModel: viewModel));
    await tester.pump();

    expect(find.text('TrackInk'), findsOneWidget);
    final theme = tester.widget<MaterialApp>(find.byType(MaterialApp)).theme!;

    expect(theme.textTheme.bodyMedium?.fontFamily, AppFonts.sans);
    expect(theme.textTheme.headlineSmall?.fontFamily, AppFonts.serif);
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

final class _EmptyReadingRepository implements ReadingRepository {
  @override
  Future<List<Reading>> getFirstPage({required int limit}) async => const [];

  @override
  Future<List<Reading>> getNextPage({
    required int limit,
    required int offset,
  }) async => const [];

  @override
  Future<ReadingStats> getStats() async {
    return const ReadingStats(
      totalReadings: 0,
      completedReadings: 0,
      totalProgress: 0,
    );
  }
}

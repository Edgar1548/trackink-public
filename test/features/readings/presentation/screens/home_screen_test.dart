import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_stats.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_repository.dart';
import 'package:trackink/src/features/readings/presentation/screens/home_screen.dart';
import 'package:trackink/src/features/readings/presentation/screens/reading_form_screen.dart';
import 'package:trackink/src/features/readings/presentation/view_models/home_view_model.dart';
import 'package:trackink/src/shared/text/app_strings.dart';

void main() {
  testWidgets('provides the visual structure for the reading list', (
    tester,
  ) async {
    final viewModel = HomeViewModel(_EmptyReadingRepository());
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(MaterialApp(home: HomeScreen(viewModel: viewModel)));
    await tester.pump();

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(SafeArea), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.byKey(HomeScreen.contentKey), findsOneWidget);
  });

  testWidgets('opens the create-reading form route', (tester) async {
    final repository = _EmptyReadingRepository();
    final viewModel = HomeViewModel(repository);
    addTearDown(viewModel.dispose);

    await tester.pumpWidget(MaterialApp(home: HomeScreen(viewModel: viewModel)));
    await tester.pump();

    await tester.tap(find.byKey(HomeScreen.createButtonKey));
    await tester.pumpAndSettle();

    expect(find.byType(ReadingFormScreen), findsOneWidget);
    expect(find.text(AppStrings.createReading), findsOneWidget);
    expect(find.byKey(ReadingFormScreen.contentKey), findsOneWidget);

    Navigator.of(
      tester.element(find.byType(ReadingFormScreen)),
    ).pop(true);
    await tester.pumpAndSettle();

    expect(repository.firstPageCalls, 2);
  });
}

final class _EmptyReadingRepository implements ReadingRepository {
  int firstPageCalls = 0;

  @override
  Future<List<Reading>> getFirstPage({required int limit}) async {
    firstPageCalls++;
    return const [];
  }

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

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/src/core/state/async_state.dart';
import 'package:trackink/src/features/readings/domain/entities/reading.dart';
import 'package:trackink/src/features/readings/domain/entities/reading_stats.dart';
import 'package:trackink/src/features/readings/domain/repositories/reading_repository.dart';
import 'package:trackink/src/features/readings/presentation/view_models/home_view_model.dart';

void main() {
  test('loads the first page and exposes loading then data', () async {
    final request = Completer<List<Reading>>();
    final repository = _FakeReadingRepository(request.future);
    final viewModel = HomeViewModel(repository, pageSize: 10);

    final load = viewModel.loadInitial();

    expect(viewModel.state, isA<AsyncLoading<HomeData>>());
    expect(repository.requestedLimit, 10);

    request.complete([_reading]);
    await load;

    final state = viewModel.state as AsyncData<HomeData>;
    expect(state.value.readings.single.id, _reading.id);
  });

  test('exposes repository failures', () async {
    final repository = _FakeReadingRepository(Future.error(Exception('failed')));
    final viewModel = HomeViewModel(repository);

    await viewModel.loadInitial();

    expect(viewModel.state, isA<AsyncError<HomeData>>());
  });
}

final _reading = Reading(
  id: 'reading-1',
  title: 'Title',
  author: 'Author',
  type: ReadingType.manga,
  status: ReadingStatus.inProgress,
  progress: 1,
  score: null,
  tags: const [],
  description: '',
  alternativeTitles: const [],
  createdAt: DateTime.utc(2026, 1, 1),
  updatedAt: DateTime.utc(2026, 1, 1),
);

final class _FakeReadingRepository implements ReadingRepository {
  _FakeReadingRepository(this.response);

  final Future<List<Reading>> response;
  int? requestedLimit;

  @override
  Future<ReadingStats> getStats() async {
    return const ReadingStats(
      totalReadings: 0,
      completedReadings: 0,
      totalProgress: 0,
    );
  }

  @override
  Future<List<Reading>> getNextPage({
    required int limit,
    required int offset,
  }) async => const [];

  @override
  Future<List<Reading>> getFirstPage({required int limit}) {
    requestedLimit = limit;
    return response;
  }
}

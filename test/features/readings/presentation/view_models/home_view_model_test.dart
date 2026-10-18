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

  test('appends the next page without duplicates or concurrent requests', () async {
    final repository = _PagingReadingRepository(
      firstPage: [_readingWithId('reading-1'), _readingWithId('reading-2')],
      nextPage: [_readingWithId('reading-2'), _readingWithId('reading-3')],
    );
    final viewModel = HomeViewModel(repository, pageSize: 2);

    await viewModel.loadInitial();
    await Future.wait([viewModel.loadMore(), viewModel.loadMore()]);

    final state = viewModel.state as AsyncData<HomeData>;
    expect(
      state.value.readings.map((reading) => reading.id),
      orderedEquals(['reading-1', 'reading-2', 'reading-3']),
    );
    expect(repository.nextPageCalls, 1);
    expect(repository.requestedOffset, 2);
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

Reading _readingWithId(String id) {
  final timestamp = DateTime.utc(2026, 1, 1);
  return Reading(
    id: id,
    title: id,
    author: 'Author',
    type: ReadingType.manga,
    status: ReadingStatus.inProgress,
    progress: 0,
    score: null,
    tags: const [],
    description: '',
    alternativeTitles: const [],
    createdAt: timestamp,
    updatedAt: timestamp,
  );
}

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

final class _PagingReadingRepository implements ReadingRepository {
  _PagingReadingRepository({required this.firstPage, required this.nextPage});

  final List<Reading> firstPage;
  final List<Reading> nextPage;
  int nextPageCalls = 0;
  int? requestedOffset;

  @override
  Future<List<Reading>> getFirstPage({required int limit}) async => firstPage;

  @override
  Future<List<Reading>> getNextPage({
    required int limit,
    required int offset,
  }) async {
    nextPageCalls++;
    requestedOffset = offset;
    return nextPage;
  }

  @override
  Future<ReadingStats> getStats() async {
    return ReadingStats(
      totalReadings: firstPage.length + 1,
      completedReadings: 0,
      totalProgress: 0,
    );
  }
}

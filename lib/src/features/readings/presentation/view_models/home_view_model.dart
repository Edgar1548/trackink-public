import 'package:flutter/foundation.dart';

import '../../../../core/state/async_state.dart';
import '../../domain/entities/reading.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/repositories/reading_repository.dart';

const defaultReadingsPageSize = 20;

class HomeData {
  const HomeData({
    required this.readings,
    required this.stats,
    required this.hasMore,
    this.isLoadingMore = false,
    this.paginationError,
  });

  final List<Reading> readings;
  final ReadingStats stats;
  final bool hasMore;
  final bool isLoadingMore;
  final Object? paginationError;

  HomeData copyWith({
    List<Reading>? readings,
    ReadingStats? stats,
    bool? hasMore,
    bool? isLoadingMore,
    Object? paginationError,
    bool clearPaginationError = false,
  }) {
    return HomeData(
      readings: readings ?? this.readings,
      stats: stats ?? this.stats,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      paginationError: clearPaginationError
          ? null
          : paginationError ?? this.paginationError,
    );
  }
}

final class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._repository, {
    this.pageSize = defaultReadingsPageSize,
  }) : assert(pageSize > 0);

  final ReadingRepository _repository;
  final int pageSize;

  AsyncState<HomeData> _state = const AsyncData(
    HomeData(
      readings: [],
      hasMore: false,
      stats: ReadingStats(
        totalReadings: 0,
        completedReadings: 0,
        totalProgress: 0,
      ),
    ),
  );
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _nextOffset = 0;

  AsyncState<HomeData> get state => _state;

  Future<void> loadInitial() async {
    if (_isLoading) return;

    _isLoading = true;
    _state = const AsyncLoading();
    notifyListeners();

    try {
      final (readings, stats) = await (
        _repository.getFirstPage(limit: pageSize),
        _repository.getStats(),
      ).wait;
      _nextOffset = readings.length;
      _state = AsyncData(
        HomeData(
          readings: List.unmodifiable(readings),
          stats: stats,
          hasMore: readings.length == pageSize,
        ),
      );
    } catch (error, stackTrace) {
      _state = AsyncError(error, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    final currentState = _state;
    if (_isLoading ||
        _isLoadingMore ||
        currentState is! AsyncData<HomeData> ||
        !currentState.value.hasMore) {
      return;
    }

    final current = currentState.value;
    _isLoadingMore = true;
    _state = AsyncData(
      current.copyWith(isLoadingMore: true, clearPaginationError: true),
    );
    notifyListeners();

    try {
      final nextPage = await _repository.getNextPage(
        limit: pageSize,
        offset: _nextOffset,
      );
      _nextOffset += nextPage.length;
      final existingIds = current.readings.map((reading) => reading.id).toSet();
      final uniqueNextPage = nextPage
          .where((reading) => existingIds.add(reading.id))
          .toList(growable: false);

      _state = AsyncData(
        current.copyWith(
          readings: List.unmodifiable([...current.readings, ...uniqueNextPage]),
          hasMore: nextPage.length == pageSize,
          isLoadingMore: false,
          clearPaginationError: true,
        ),
      );
    } catch (error) {
      _state = AsyncData(
        current.copyWith(isLoadingMore: false, paginationError: error),
      );
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }
}

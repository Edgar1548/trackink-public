import 'package:flutter/foundation.dart';

import '../../../../core/state/async_state.dart';
import '../../domain/entities/reading.dart';
import '../../domain/entities/reading_stats.dart';
import '../../domain/repositories/reading_repository.dart';

const defaultReadingsPageSize = 20;

class HomeData {
  const HomeData({required this.readings, required this.stats});

  final List<Reading> readings;
  final ReadingStats stats;
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
      stats: ReadingStats(
        totalReadings: 0,
        completedReadings: 0,
        totalProgress: 0,
      ),
    ),
  );
  bool _isLoading = false;

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
      _state = AsyncData(
        HomeData(readings: List.unmodifiable(readings), stats: stats),
      );
    } catch (error, stackTrace) {
      _state = AsyncError(error, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

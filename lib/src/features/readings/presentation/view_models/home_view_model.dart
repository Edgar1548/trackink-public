import 'package:flutter/foundation.dart';

import '../../../../core/state/async_state.dart';
import '../../domain/entities/reading.dart';
import '../../domain/repositories/reading_repository.dart';

const defaultReadingsPageSize = 20;

final class HomeViewModel extends ChangeNotifier {
  HomeViewModel(
    this._repository, {
    this.pageSize = defaultReadingsPageSize,
  }) : assert(pageSize > 0);

  final ReadingRepository _repository;
  final int pageSize;

  AsyncState<List<Reading>> _state = const AsyncData([]);
  bool _isLoading = false;

  AsyncState<List<Reading>> get state => _state;

  Future<void> loadInitial() async {
    if (_isLoading) return;

    _isLoading = true;
    _state = const AsyncLoading();
    notifyListeners();

    try {
      final readings = await _repository.getFirstPage(limit: pageSize);
      _state = AsyncData(List.unmodifiable(readings));
    } catch (error, stackTrace) {
      _state = AsyncError(error, stackTrace: stackTrace);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

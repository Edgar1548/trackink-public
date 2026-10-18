import 'dart:async';

import 'package:flutter/material.dart';

import 'features/readings/data/local/daos/reading_dao.dart';
import 'features/readings/data/local/database/app_database.dart';
import 'features/readings/data/repositories/local_reading_repository.dart';
import 'features/readings/presentation/screens/home_screen.dart';
import 'features/readings/presentation/view_models/home_view_model.dart';
import 'shared/text/app_strings.dart';
import 'shared/theme/app_theme.dart';

class TrackInkApp extends StatefulWidget {
  const TrackInkApp({super.key, this.homeViewModel});

  final HomeViewModel? homeViewModel;

  @override
  State<TrackInkApp> createState() => _TrackInkAppState();
}

class _TrackInkAppState extends State<TrackInkApp> {
  AppDatabase? _database;
  late final HomeViewModel _homeViewModel;
  late final bool _ownsHomeViewModel;

  @override
  void initState() {
    super.initState();
    final injected = widget.homeViewModel;
    if (injected != null) {
      _homeViewModel = injected;
      _ownsHomeViewModel = false;
      return;
    }

    _ownsHomeViewModel = true;
    final database = AppDatabase.defaults();
    _database = database;
    _homeViewModel = HomeViewModel(
      LocalReadingRepository(ReadingDao(database)),
    );
  }

  @override
  void dispose() {
    if (_ownsHomeViewModel) {
      _homeViewModel.dispose();
      final database = _database;
      if (database != null) unawaited(database.close());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.light,
      home: HomeScreen(viewModel: _homeViewModel),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../../core/state/async_state.dart';
import '../../domain/use_cases/create_reading.dart';
import '../view_models/home_view_model.dart';
import '../widgets/reading_card.dart';
import '../widgets/reading_empty_state.dart';
import '../widgets/reading_stats_summary.dart';
import 'reading_form_screen.dart';

const _loadMoreThreshold = 160.0;
const _loadMoreIndicatorKey = Key('home-load-more-indicator');

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.viewModel,
    this.createReading,
  });

  final HomeViewModel viewModel;
  final CreateReading? createReading;

  static const contentKey = Key('home-content');
  static const createButtonKey = Key('create-reading-button');

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    widget.viewModel.loadInitial();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel == widget.viewModel) return;
    oldWidget.viewModel.removeListener(_onViewModelChanged);
    widget.viewModel.addListener(_onViewModelChanged);
    widget.viewModel.loadInitial();
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        key: HomeScreen.createButtonKey,
        tooltip: AppStrings.addReading,
        backgroundColor: AppPalette.terracotta,
        foregroundColor: AppPalette.white,
        onPressed: _openCreateReading,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Expanded(
              key: HomeScreen.contentKey,
              child: _contentFor(widget.viewModel.state),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCreateReading() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => ReadingFormScreen(createReading: widget.createReading),
      ),
    );

    if (created == true) await widget.viewModel.loadInitial();
  }

  Widget _contentFor(AsyncState<HomeData> state) {
    return switch (state) {
      AsyncLoading<HomeData>() => const Center(child: AppLoadingIndicator()),
      AsyncError<HomeData>() => AppErrorView(
        message: AppStrings.loadReadingsError,
        onRetry: widget.viewModel.loadInitial,
      ),
      AsyncData<HomeData>(:final value) => _HomeDataView(
        data: value,
        onLoadMore: widget.viewModel.loadMore,
      ),
    };
  }
}

class _HomeDataView extends StatelessWidget {
  const _HomeDataView({required this.data, required this.onLoadMore});

  final HomeData data;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReadingStatsSummary(stats: data.stats),
        const SizedBox(height: AppSpacing.large),
        Expanded(
          child: data.readings.isEmpty
              ? const ReadingEmptyState()
              : NotificationListener<ScrollUpdateNotification>(
                  onNotification: (notification) {
                    if (notification.metrics.extentAfter <=
                        _loadMoreThreshold) {
                      onLoadMore();
                    }
                    return false;
                  },
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.large,
                      0,
                      AppSpacing.large,
                      AppSpacing.large,
                    ),
                    itemCount:
                        data.readings.length + (data.isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == data.readings.length) {
                        return const Padding(
                          key: _loadMoreIndicatorKey,
                          padding: EdgeInsets.symmetric(
                            vertical: AppSpacing.medium,
                          ),
                          child: Center(child: AppLoadingIndicator()),
                        );
                      }

                      return ReadingCard(
                        reading: data.readings[index],
                        onTap: () {},
                      );
                    },
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSpacing.medium),
                  ),
                ),
        ),
      ],
    );
  }
}

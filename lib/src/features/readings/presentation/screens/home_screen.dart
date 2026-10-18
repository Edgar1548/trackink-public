import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/app_error_view.dart';
import '../../../../shared/widgets/app_loading_indicator.dart';
import '../../../../core/state/async_state.dart';
import '../view_models/home_view_model.dart';
import '../widgets/reading_card.dart';
import '../widgets/reading_empty_state.dart';
import '../widgets/reading_stats_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  static const contentKey = Key('home-content');

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

  Widget _contentFor(AsyncState<HomeData> state) {
    return switch (state) {
      AsyncLoading<HomeData>() => const Center(child: AppLoadingIndicator()),
      AsyncError<HomeData>() => AppErrorView(
        message: AppStrings.loadReadingsError,
        onRetry: widget.viewModel.loadInitial,
      ),
      AsyncData<HomeData>(:final value) => _HomeDataView(data: value),
    };
  }
}

class _HomeDataView extends StatelessWidget {
  const _HomeDataView({required this.data});

  final HomeData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReadingStatsSummary(stats: data.stats),
        const SizedBox(height: AppSpacing.large),
        Expanded(
          child: data.readings.isEmpty
              ? const ReadingEmptyState()
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.large,
                    0,
                    AppSpacing.large,
                    AppSpacing.large,
                  ),
                  itemCount: data.readings.length,
                  itemBuilder: (context, index) => ReadingCard(
                    reading: data.readings[index],
                    onTap: () {},
                  ),
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.medium),
                ),
        ),
      ],
    );
  }
}

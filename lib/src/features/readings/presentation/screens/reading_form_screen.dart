import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/app_option_selector.dart';
import '../../../../shared/widgets/app_score_selector.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/reading.dart';
import '../view_models/reading_form_view_model.dart';

const _typeOptions = [
  AppOption(label: AppStrings.typeManga, value: ReadingType.manga),
  AppOption(label: AppStrings.typeManhwa, value: ReadingType.manhwa),
  AppOption(label: AppStrings.typeManhua, value: ReadingType.manhua),
  AppOption(label: AppStrings.typeTvSeries, value: ReadingType.tvSeries),
  AppOption(label: AppStrings.typeMovie, value: ReadingType.movie),
  AppOption(label: AppStrings.typeBook, value: ReadingType.book),
  AppOption(label: AppStrings.typeComic, value: ReadingType.comic),
];

const _statusOptions = [
  AppOption(
    label: AppStrings.statusInProgress,
    value: ReadingStatus.inProgress,
  ),
  AppOption(
    label: AppStrings.statusCompleted,
    value: ReadingStatus.completed,
  ),
  AppOption(label: AppStrings.statusHiatus, value: ReadingStatus.hiatus),
  AppOption(
    label: AppStrings.statusNoTranslation,
    value: ReadingStatus.noTranslation,
  ),
  AppOption(label: AppStrings.statusDropped, value: ReadingStatus.dropped),
  AppOption(label: AppStrings.statusPlanned, value: ReadingStatus.planned),
];

class ReadingFormScreen extends StatefulWidget {
  const ReadingFormScreen({super.key, this.viewModel});

  final ReadingFormViewModel? viewModel;

  static const contentKey = Key('reading-form-content');

  @override
  State<ReadingFormScreen> createState() => _ReadingFormScreenState();
}

class _ReadingFormScreenState extends State<ReadingFormScreen> {
  late final ReadingFormViewModel viewModel;
  late final bool ownsViewModel;

  @override
  void initState() {
    super.initState();
    final injected = widget.viewModel;
    viewModel = injected ?? ReadingFormViewModel();
    ownsViewModel = injected == null;
    viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    viewModel.removeListener(_onViewModelChanged);
    if (ownsViewModel) viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createReading)),
      body: SafeArea(
        child: ListView(
          key: ReadingFormScreen.contentKey,
          padding: const EdgeInsets.all(AppSpacing.large),
          children: [
            AppTextField(
              controller: viewModel.titleController,
              label: AppStrings.title,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: viewModel.authorController,
              label: AppStrings.author,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: viewModel.progressController,
              label: AppStrings.progress,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.readingType,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            AppOptionSelector<ReadingType>(
              value: viewModel.type,
              options: _typeOptions,
              onChanged: viewModel.setType,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.status,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            AppOptionSelector<ReadingStatus>(
              value: viewModel.status,
              options: _statusOptions,
              onChanged: viewModel.setStatus,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.score,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            AppScoreSelector(
              value: viewModel.score,
              onChanged: viewModel.setScore,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: viewModel.tagsController,
              label: AppStrings.tags,
              hint: AppStrings.tagsHint,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: viewModel.descriptionController,
              label: AppStrings.description,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: viewModel.alternativeTitlesController,
              label: AppStrings.alternativeTitles,
              hint: AppStrings.alternativeTitlesHint,
            ),
          ],
        ),
      ),
    );
  }
}

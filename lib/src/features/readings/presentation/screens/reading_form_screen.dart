import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/app_option_selector.dart';
import '../../../../shared/widgets/app_score_selector.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/reading.dart';

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
  const ReadingFormScreen({super.key});

  static const contentKey = Key('reading-form-content');

  @override
  State<ReadingFormScreen> createState() => _ReadingFormScreenState();
}

class _ReadingFormScreenState extends State<ReadingFormScreen> {
  final titleController = TextEditingController();
  final authorController = TextEditingController();
  final progressController = TextEditingController();
  final tagsController = TextEditingController();
  final descriptionController = TextEditingController();
  final alternativeTitlesController = TextEditingController();
  ReadingType type = ReadingType.manga;
  ReadingStatus status = ReadingStatus.inProgress;
  double? score;

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    progressController.dispose();
    tagsController.dispose();
    descriptionController.dispose();
    alternativeTitlesController.dispose();
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
              controller: titleController,
              label: AppStrings.title,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: authorController,
              label: AppStrings.author,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: progressController,
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
              value: type,
              options: _typeOptions,
              onChanged: (value) => setState(() => type = value),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.status,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            AppOptionSelector<ReadingStatus>(
              value: status,
              options: _statusOptions,
              onChanged: (value) => setState(() => status = value),
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.score,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.small),
            AppScoreSelector(
              value: score,
              onChanged: (value) => setState(() => score = value),
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: tagsController,
              label: AppStrings.tags,
              hint: AppStrings.tagsHint,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: descriptionController,
              label: AppStrings.description,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: AppSpacing.medium),
            AppTextField(
              controller: alternativeTitlesController,
              label: AppStrings.alternativeTitles,
              hint: AppStrings.alternativeTitlesHint,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../../../shared/widgets/app_text_field.dart';

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

import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';

class ReadingEmptyState extends StatelessWidget {
  const ReadingEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.large),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_stories_outlined,
              size: 48,
              color: AppPalette.espressoMuted,
            ),
            const SizedBox(height: AppSpacing.medium),
            Text(
              AppStrings.emptyReadingsTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.small),
            Text(
              AppStrings.emptyReadingsMessage,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

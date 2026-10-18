import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/entities/reading.dart';

class ReadingCard extends StatelessWidget {
  const ReadingCard({
    super.key,
    required this.reading,
    required this.onTap,
  });

  final Reading reading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(reading.status);

    return Material(
      color: AppPalette.card,
      borderRadius: BorderRadius.circular(AppRadius.large),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 76,
                height: 100,
                padding: const EdgeInsets.all(AppSpacing.small),
                decoration: BoxDecoration(
                  color: AppPalette.terracotta,
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                ),
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.extraSmall,
                    vertical: AppSpacing.extraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: statusStyle.background,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    _statusLabel(reading.status),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: statusStyle.foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            reading.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.small),
                        const Icon(
                          Icons.menu_book_outlined,
                          color: AppPalette.terracotta,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.extraSmall),
                        Text('${reading.progress}'),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Text(
                      reading.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.small),
                    Wrap(
                      spacing: AppSpacing.extraSmall,
                      runSpacing: AppSpacing.extraSmall,
                      children: [
                        for (final tag in reading.tags.take(3))
                          _TagChip(label: tag),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.small,
        vertical: AppSpacing.extraSmall,
      ),
      decoration: BoxDecoration(
        color: AppPalette.tagBackground,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelSmall),
    );
  }
}

String _statusLabel(ReadingStatus status) => switch (status) {
  ReadingStatus.inProgress => AppStrings.statusInProgress,
  ReadingStatus.completed => AppStrings.statusCompleted,
  ReadingStatus.hiatus => AppStrings.statusHiatus,
  ReadingStatus.noTranslation => AppStrings.statusNoTranslation,
  ReadingStatus.dropped => AppStrings.statusDropped,
  ReadingStatus.planned => AppStrings.statusPlanned,
};

({Color background, Color foreground}) _statusStyle(ReadingStatus status) {
  return switch (status) {
    ReadingStatus.completed => (
      background: AppPalette.successSubtle,
      foreground: AppPalette.success,
    ),
    ReadingStatus.hiatus => (
      background: AppPalette.warningSubtle,
      foreground: AppPalette.warning,
    ),
    ReadingStatus.inProgress => (
      background: AppPalette.creamDark,
      foreground: AppPalette.espresso,
    ),
    ReadingStatus.noTranslation ||
    ReadingStatus.dropped ||
    ReadingStatus.planned => (
      background: AppPalette.mutedStatusBackground,
      foreground: AppPalette.espressoMuted,
    ),
  };
}

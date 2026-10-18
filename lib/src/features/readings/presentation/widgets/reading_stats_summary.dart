import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';
import '../../domain/entities/reading_stats.dart';

class ReadingStatsSummary extends StatelessWidget {
  const ReadingStatsSummary({super.key, required this.stats});

  final ReadingStats stats;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
      child: Row(
        children: [
          _StatItem(
            label: AppStrings.totalReadings,
            value: stats.totalReadings,
          ),
          _StatItem(
            label: AppStrings.completedReadings,
            value: stats.completedReadings,
          ),
          _StatItem(
            label: AppStrings.totalProgress,
            value: stats.totalProgress,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$value', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.extraSmall),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

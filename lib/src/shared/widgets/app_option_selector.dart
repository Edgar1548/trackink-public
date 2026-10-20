import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class AppOption<T> {
  const AppOption({required this.label, required this.value});

  final String label;
  final T value;
}

class AppOptionSelector<T> extends StatelessWidget {
  const AppOptionSelector({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<AppOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.small,
      runSpacing: AppSpacing.small,
      children: [
        for (final option in options)
          ChoiceChip(
            label: Text(option.label),
            selected: option.value == value,
            selectedColor: AppPalette.espresso,
            backgroundColor: AppPalette.card,
            labelStyle: TextStyle(
              color: option.value == value
                  ? AppPalette.white
                  : AppPalette.espressoMuted,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.medium),
            ),
            onSelected: (_) => onChanged(option.value),
          ),
      ],
    );
  }
}

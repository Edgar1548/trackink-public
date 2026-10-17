import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

enum AppSnackBarType { success, warning, error }

SnackBar appSnackBar({
  required String title,
  required String message,
  AppSnackBarType type = AppSnackBarType.success,
}) {
  final colors = _colorsFor(type);

  return SnackBar(
    backgroundColor: colors.background,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.foreground,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.extraSmall),
        Text(message, style: TextStyle(color: colors.foreground)),
      ],
    ),
  );
}

({Color background, Color foreground}) _colorsFor(AppSnackBarType type) {
  return switch (type) {
    AppSnackBarType.success => (
      background: AppPalette.successSubtle,
      foreground: AppPalette.success,
    ),
    AppSnackBarType.warning => (
      background: AppPalette.warningSubtle,
      foreground: AppPalette.warning,
    ),
    AppSnackBarType.error => (
      background: AppPalette.dangerSubtle,
      foreground: AppPalette.danger,
    ),
  };
}

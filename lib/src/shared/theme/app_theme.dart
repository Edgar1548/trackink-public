import 'package:flutter/material.dart';

import 'app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppPalette.terracotta,
      brightness: Brightness.light,
      surface: AppPalette.cream,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.cream,
      fontFamily: AppFonts.sans,
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          color: AppPalette.espresso,
          fontFamily: AppFonts.serif,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: AppPalette.espresso),
        bodyMedium: TextStyle(color: AppPalette.espressoMuted),
      ),
    );
  }
}

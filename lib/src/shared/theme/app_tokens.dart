import 'package:flutter/material.dart';

abstract final class AppFonts {
  static const serif = 'CrimsonPro';
  static const sans = 'Inter';
}

abstract final class AppPalette {
  static const cream = Color(0xFFFFF8F0);
  static const creamDark = Color(0xFFF5E1C8);
  static const espresso = Color(0xFF3B2F25);
  static const espressoMuted = Color(0xFF6B5A4E);
  static const terracotta = Color(0xFFC85C3F);
  static const success = Color(0xFF3D6B4F);
  static const successSubtle = Color(0xFFEBF4ED);
  static const warning = Color(0xFFB8760A);
  static const warningSubtle = Color(0xFFFEF6E4);
  static const danger = Color(0xFFA8281A);
  static const dangerSubtle = Color(0xFFFAEEEC);
  static const card = Colors.white;
  static const tagBackground = Color(0xFFFDECD8);
  static const mutedStatusBackground = Color(0xFFE8DDD4);
  static const white = Colors.white;
}

abstract final class AppSpacing {
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
}

abstract final class AppRadius {
  static const small = 6.0;
  static const medium = 12.0;
  static const large = 14.0;
}

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
  static const white = Colors.white;
}

abstract final class AppSpacing {
  static const extraSmall = 4.0;
  static const small = 8.0;
  static const medium = 12.0;
  static const large = 16.0;
}

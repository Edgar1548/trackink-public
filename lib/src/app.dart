import 'package:flutter/material.dart';

import 'features/readings/presentation/screens/home_screen.dart';
import 'shared/text/app_strings.dart';
import 'shared/theme/app_theme.dart';

class TrackInkApp extends StatelessWidget {
  const TrackInkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.light,
      home: const HomeScreen(),
    );
  }
}

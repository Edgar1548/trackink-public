import 'package:flutter/material.dart';

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
      home: const _BootstrapScreen(),
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text(AppStrings.appName)));
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';

class TemporaryCreateReadingScreen extends StatelessWidget {
  const TemporaryCreateReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createReading)),
      body: const Center(child: Text(AppStrings.createReadingComingSoon)),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';

class ReadingFormScreen extends StatelessWidget {
  const ReadingFormScreen({super.key});

  static const contentKey = Key('reading-form-content');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.createReading)),
      body: const SafeArea(child: SizedBox.expand(key: contentKey)),
    );
  }
}

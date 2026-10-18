import 'package:flutter/material.dart';

import '../../../../shared/text/app_strings.dart';
import '../../../../shared/theme/app_tokens.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const contentKey = Key('home-content');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.large),
              child: Text(
                AppStrings.appName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const Expanded(child: SizedBox(key: contentKey)),
          ],
        ),
      ),
    );
  }
}

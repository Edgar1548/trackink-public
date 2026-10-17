import 'package:flutter/material.dart';

import '../text/app_strings.dart';
import '../theme/app_tokens.dart';

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
  });

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppStrings.loading,
      child: SizedBox.square(
        dimension: size,
        child: CircularProgressIndicator(
          color: AppPalette.espressoMuted,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

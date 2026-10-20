import 'package:flutter/material.dart';

import '../theme/app_tokens.dart';

class AppScoreSelector extends StatelessWidget {
  const AppScoreSelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.starSize = 40,
  });

  final double? value;
  final ValueChanged<double?> onChanged;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.extraSmall,
          ),
          child: SizedBox(
            width: starSize,
            height: starSize,
            child: Stack(
              children: [
                Icon(
                  Icons.star,
                  size: starSize,
                  color: AppPalette.creamDark,
                ),
                ClipRect(
                  clipper: _StarClipper(_fillFraction(index)),
                  child: Icon(
                    Icons.star,
                    size: starSize,
                    color: AppPalette.terracotta,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        key: Key('score-star-${index + 1}-half'),
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _toggle(index + 0.5),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        key: Key('score-star-${index + 1}-full'),
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _toggle(index + 1.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  double _fillFraction(int index) {
    if (value == null) return 0;
    if (value! >= index + 1) return 1;
    if (value! >= index + 0.5) return 0.5;
    return 0;
  }

  void _toggle(double next) {
    onChanged(value == next ? null : next);
  }
}

class _StarClipper extends CustomClipper<Rect> {
  const _StarClipper(this.fraction);

  final double fraction;

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * fraction, size.height);
  }

  @override
  bool shouldReclip(covariant _StarClipper oldClipper) {
    return oldClipper.fraction != fraction;
  }
}

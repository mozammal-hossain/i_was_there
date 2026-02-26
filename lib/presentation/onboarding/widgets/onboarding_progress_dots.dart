import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Progress indicator for onboarding: [total] dots, [currentIndex] is active (0-based).
class OnboardingProgressDots extends StatelessWidget {
  const OnboardingProgressDots({
    super.key,
    required this.currentIndex,
    this.total = 2,
  });

  final int currentIndex;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == currentIndex;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.3),
          ),
        );
      }),
    );
  }
}

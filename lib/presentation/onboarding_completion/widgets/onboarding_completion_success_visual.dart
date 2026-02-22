import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class OnboardingCompletionSuccessVisual extends StatelessWidget {
  const OnboardingCompletionSuccessVisual({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 4,
            ),
          ),
          child: Icon(Icons.check_circle, size: 64, color: AppColors.primary),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight,
                width: 4,
              ),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

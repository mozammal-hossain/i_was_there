import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class OnboardingHowStepItem extends StatelessWidget {
  const OnboardingHowStepItem({
    super.key,
    required this.stepNumber,
    required this.title,
    required this.icon,
    this.showLine = true,
  });

  final int stepNumber;
  final String title;
  final IconData icon;
  final bool showLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: AppSize.stepIconSize,
              height: AppSize.stepIconSize,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: AppSize.iconL),
            ),
            if (showLine)
              Container(
                width: AppSize.spacingXs,
                height: AppSize.buttonHeightSm,
                color: AppColors.primary.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: AppSize.spacingXl),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: AppSize.spacingM,
              bottom: AppSize.spacingXl3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STEP $stepNumber',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    letterSpacing: AppSize.letterSpacingXl,
                  ),
                ),
                const SizedBox(height: AppSize.spacingS),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    height: AppSize.lineHeightBody,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

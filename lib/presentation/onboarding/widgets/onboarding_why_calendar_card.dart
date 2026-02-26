import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class OnboardingWhyCalendarCard extends StatelessWidget {
  const OnboardingWhyCalendarCard({
    super.key,
    required this.calendarSyncEnabled,
  });

  final bool calendarSyncEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final subtitleColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingL),
      child: Container(
        padding: const EdgeInsets.all(AppSize.spacingXl),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF334155).withValues(alpha: 0.5)
              : Colors.white,
          borderRadius: BorderRadius.circular(AppSize.radiusL),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: AppSize.spacingS,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.avatarLg,
              height: AppSize.avatarLg,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSize.radiusL),
              ),
              child: Icon(
                Icons.calendar_today,
                color: AppColors.primary,
                size: AppSize.iconL3,
              ),
            ),
            const SizedBox(width: AppSize.spacingL),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Google Calendar Sync',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: AppSize.spacingS),
                  Text(
                    'See all your activity and gym sessions in one place.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

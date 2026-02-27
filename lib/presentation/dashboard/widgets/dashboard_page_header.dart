import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

/// Dashboard header: "Places" title, "Weekly Attendance" subtitle, optional Override button, avatar.
class DashboardPageHeader extends StatelessWidget {
  const DashboardPageHeader({
    super.key,
    required this.theme,
    required this.isDark,
    this.onManualOverride,
  });

  final ThemeData theme;
  final bool isDark;
  final VoidCallback? onManualOverride;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.spacingXl,
        AppSize.spacingXl,
        AppSize.spacingXl,
        AppSize.spacingL,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.places,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.white
                        : const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: AppSize.spacingXs),
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.weeklyAttendance,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (onManualOverride != null) ...[
                      const SizedBox(width: AppSize.spacingM3),
                      TextButton(
                        onPressed: onManualOverride,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSize.spacingM,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.overrideLabel,
                          style: TextStyle(
                            fontSize: AppSize.fontBody2,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: AppSize.radiusXl2,
            backgroundColor: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFE2E8F0),
            child: Icon(
              Icons.person_outline,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

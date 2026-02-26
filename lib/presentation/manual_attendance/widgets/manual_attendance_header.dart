import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/manual_attendance/utils/manual_attendance_utils.dart';

/// Manual attendance sheet header: drag handle, date text, "Change date" button.
class ManualAttendanceHeader extends StatelessWidget {
  const ManualAttendanceHeader({
    super.key,
    required this.selectedDate,
    required this.theme,
    required this.isDark,
    required this.onChangeDateTap,
  });

  final DateTime selectedDate;
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onChangeDateTap;

  @override
  Widget build(BuildContext context) {
    final dateStr = manualAttendanceFormatDate(selectedDate);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSize.spacingM3),
        Center(
          child: Container(
            width: AppSize.stepIconSize,
            height: AppSize.progressHeight,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(AppSize.radiusS),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.spacingXl3,
            AppSize.spacingL,
            AppSize.spacingXl3,
            AppSize.spacingL,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateStr,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: AppSize.spacingS),
                    Text(
                      'Manual Presence Override',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: AppSize.fontBody,
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: (isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFF1F5F9))
                    .withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(AppSize.radiusL),
                child: InkWell(
                  onTap: onChangeDateTap,
                  borderRadius: BorderRadius.circular(AppSize.radiusL),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.spacingL,
                      vertical: AppSize.spacingM3,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: AppSize.iconM,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: AppSize.spacingM),
                        Text(
                          'Change date',
                          style: TextStyle(
                            fontSize: AppSize.fontBodySm,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

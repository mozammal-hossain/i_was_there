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
        const SizedBox(height: 12),
        Center(
          child: Container(
            width: 40,
            height: 6,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
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
                    const SizedBox(height: 4),
                    Text(
                      'Manual Presence Override',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: 15,
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
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: onChangeDateTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Change date',
                          style: TextStyle(
                            fontSize: 14,
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

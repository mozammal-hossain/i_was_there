import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class HistoryCalendarGrid extends StatelessWidget {
  const HistoryCalendarGrid({
    super.key,
    required this.viewMonth,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.hasPresence,
    required this.isToday,
    required this.selectedDay,
    required this.theme,
    required this.isDark,
    required this.onDayTap,
  });

  final DateTime viewMonth;
  final int daysInMonth;
  final int firstWeekday;
  final bool Function(int day) hasPresence;
  final bool Function(int day) isToday;
  final int? selectedDay;
  final ThemeData theme;
  final bool isDark;
  final void Function(int day) onDayTap;

  @override
  Widget build(BuildContext context) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Column(
      children: [
        Row(
          children: weekdays
              .map(
                (d) => Expanded(
                  child: Center(
                    child: Text(
                      d,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: AppSize.letterSpacingMd,
                        color: isDark
                            ? const Color(0xFF64748B)
                            : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: AppSize.spacingM),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          mainAxisSpacing: AppSize.spacingM,
          crossAxisSpacing: AppSize.spacingM,
          childAspectRatio: 1,
          children: [
            ...List.filled(firstWeekday, const SizedBox.shrink()),
            ...List.generate(daysInMonth, (i) {
              final day = i + 1;
              final hasP = hasPresence(day);
              final isSelected = selectedDay == day;
              final today = isToday(day);
              final highlight = today || isSelected;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onDayTap(day),
                  borderRadius: BorderRadius.circular(AppSize.radiusL),
                  child: Container(
                    decoration: BoxDecoration(
                      color: highlight
                          ? AppColors.primary.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            )
                          : (isDark
                                ? const Color(0xFF334155).withValues(alpha: 0.4)
                                : const Color(0xFFF1F5F9)),
                      borderRadius: BorderRadius.circular(AppSize.radiusL),
                      border: highlight
                          ? Border.all(
                              color: AppColors.primary,
                              width: AppSize.spacingXs,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: highlight
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: highlight
                                ? AppColors.primary
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A)),
                          ),
                        ),
                        const SizedBox(height: AppSize.spacingS),
                        Container(
                          width: AppSize.spacingS2,
                          height: AppSize.spacingS2,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasP
                                ? AppColors.primary
                                : (isDark
                                      ? const Color(0xFF475569)
                                      : const Color(0xFFCBD5E1)),
                            border: hasP
                                ? null
                                : Border.all(
                                    color: isDark
                                        ? const Color(0xFF475569)
                                        : const Color(0xFF94A3B8),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

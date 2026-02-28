import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class HistoryCalendarGrid extends StatelessWidget {
  const HistoryCalendarGrid({
    super.key,
    required this.viewMonth,
    required this.daysInMonth,
    required this.firstWeekday,
    required this.presenceByDayPerPlace,
    required this.hasPresence,
    required this.isToday,
    required this.selectedDay,
    required this.theme,
    required this.isDark,
    required this.onDayTap,
    this.onDayLongPress,
    this.selectedPlaceId,
    this.placeColors = const {},
  });

  final DateTime viewMonth;
  final int daysInMonth;
  final int firstWeekday;

  /// detailed presence data used to render colored segments
  final Map<DateTime, Map<String, bool>> presenceByDayPerPlace;
  final bool Function(int day) hasPresence;
  final bool Function(int day) isToday;
  final int? selectedDay;
  final ThemeData theme;
  final bool isDark;
  final void Function(int day) onDayTap;
  final void Function(int day)? onDayLongPress;
  final String? selectedPlaceId;
  final Map<String, Color> placeColors;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final base = [
      l10n.sun,
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
    ];
    final firstDayIndex = MaterialLocalizations.of(
      context,
    ).firstDayOfWeekIndex; // 0=Sunday
    final weekdays = List<String>.generate(
      7,
      (i) => base[(firstDayIndex + i) % 7],
    );
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
              final dayDate = DateTime(viewMonth.year, viewMonth.month, day);
              final segments = presenceByDayPerPlace[dayDate] ?? {};
              final segmentsCount = segments.values.where((v) => v).length;
              final isSelected = selectedDay == day;
              final today = isToday(day);
              final highlight = today || isSelected;
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onDayTap(day),
                  onLongPress: onDayLongPress == null
                      ? null
                      : () => onDayLongPress!(day),
                  borderRadius: BorderRadius.circular(AppSize.radiusL),
                  child: Semantics(
                    label: _semanticsForDay(day, hasP, segmentsCount),
                    button: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: highlight
                            ? AppColors.primary.withValues(
                                alpha: isDark ? 0.2 : 0.1,
                              )
                            : (isDark
                                  ? const Color(
                                      0xFF334155,
                                    ).withValues(alpha: 0.4)
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
                          if (segmentsCount > 0) ...[
                            _buildSegmentIndicators(day),
                          ] else
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
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  static const int _maxSegments = 3;

  Widget _buildSegmentIndicators(int day) {
    final date = DateTime(viewMonth.year, viewMonth.month, day);
    final segments = presenceByDayPerPlace[date] ?? {};
    final presentPlaces = segments.entries
        .where(
          (e) =>
              e.value && (selectedPlaceId == null || e.key == selectedPlaceId),
        )
        .toList();
    if (presentPlaces.isEmpty) return const SizedBox.shrink();
    final display = presentPlaces.take(_maxSegments).toList();
    final extra = presentPlaces.length - display.length;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final entry in display)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: placeColors[entry.key] ?? AppColors.primary,
            ),
            width: AppSize.spacingM2,
            height: AppSize.spacingM2,
            margin: const EdgeInsets.symmetric(horizontal: 1),
          ),
        if (extra > 0)
          Text(
            '+$extra',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
      ],
    );
  }

  String _semanticsForDay(int day, bool hasPresence, int segmentsCount) {
    final buffer = StringBuffer();
    buffer.write('Day $day');
    if (hasPresence) {
      buffer.write(', present');
      if (segmentsCount > 1) {
        buffer.write(' ($segmentsCount places)');
      }
    }
    if (selectedDay == day) buffer.write(', selected');
    if (isToday(day)) buffer.write(', today');
    return buffer.toString();
  }
}

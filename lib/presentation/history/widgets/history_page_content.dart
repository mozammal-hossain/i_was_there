import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/domain/presence/entities/presence.dart';
import 'package:i_was_there/presentation/history/utils/history_utils.dart';
import 'package:i_was_there/presentation/history/widgets/history_calendar_grid.dart';
import 'package:i_was_there/presentation/history/widgets/history_day_details_section.dart';
import 'package:i_was_there/presentation/history/widgets/history_month_nav.dart';

/// Scrollable content for [HistoryPage]: month nav, calendar grid, day details.
class HistoryPageContent extends StatelessWidget {
  const HistoryPageContent({
    super.key,
    required this.viewMonth,
    required this.presenceByDay,
    required this.loadingPresence,
    required this.selectedDay,
    required this.dayPresences,
    required this.loadingDayDetails,
    required this.places,
    required this.theme,
    required this.isDark,
    required this.onMonthChanged,
    required this.onDaySelected,
  });

  final DateTime viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final List<Place> places;
  final ThemeData theme;
  final bool isDark;
  final void Function(DateTime month) onMonthChanged;
  final void Function(int? day) onDaySelected;

  int get _daysInMonth =>
      historyDaysInMonth(viewMonth.year, viewMonth.month);

  int get _firstWeekday =>
      historyFirstWeekdayOfMonth(viewMonth);

  int? get _effectiveSelectedDay {
    if (selectedDay == null) return null;
    if (selectedDay! < 1 || selectedDay! > _daysInMonth) return null;
    return selectedDay;
  }

  bool _hasPresence(int day) {
    final d = DateTime(viewMonth.year, viewMonth.month, day);
    return presenceByDay[d] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          HistoryMonthNav(
            viewMonth: viewMonth,
            theme: theme,
            isDark: isDark,
            onPrev: () => onMonthChanged(DateTime(
              viewMonth.year,
              viewMonth.month - 1,
            )),
            onNext: () => onMonthChanged(DateTime(
              viewMonth.year,
              viewMonth.month + 1,
            )),
          ),
          const SizedBox(height: 16),
          if (loadingPresence)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            HistoryCalendarGrid(
              viewMonth: viewMonth,
              daysInMonth: _daysInMonth,
              firstWeekday: _firstWeekday,
              hasPresence: _hasPresence,
              isToday: (day) => historyIsToday(viewMonth, day),
              selectedDay: _effectiveSelectedDay,
              theme: theme,
              isDark: isDark,
              onDayTap: onDaySelected,
            ),
          const SizedBox(height: 40),
          HistoryDayDetailsSection(
            viewMonth: viewMonth,
            selectedDay: _effectiveSelectedDay,
            dayPresences: _effectiveSelectedDay != null ? dayPresences : const [],
            loadingDayDetails:
                _effectiveSelectedDay != null ? loadingDayDetails : false,
            places: places,
            theme: theme,
            isDark: isDark,
            monthName: historyMonthName(viewMonth.month),
          ),
        ],
      ),
    );
  }
}

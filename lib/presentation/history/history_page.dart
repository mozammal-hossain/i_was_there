import 'package:flutter/material.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/domain/presence/entities/presence.dart';
import 'package:i_was_there/presentation/history/utils/history_utils.dart';
import 'package:i_was_there/presentation/history/widgets/history_calendar_grid.dart';
import 'package:i_was_there/presentation/history/widgets/history_day_details_section.dart';
import 'package:i_was_there/presentation/history/widgets/history_filter_chips.dart';
import 'package:i_was_there/presentation/history/widgets/history_header.dart';
import 'package:i_was_there/presentation/history/widgets/history_month_nav.dart';

/// Presence history calendar. Month view, filter chips, day details.
/// All data and loading state come from [HistoryBloc]; this page only renders and dispatches events.
class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    this.places = const [],
    required this.viewMonth,
    this.presenceByDay = const {},
    this.loadingPresence = false,
    this.selectedDay,
    this.dayPresences = const [],
    this.loadingDayDetails = false,
    this.onBack,
    this.onMonthChanged,
    this.onDaySelected,
    this.onAddManual,
  });

  final List<Place> places;
  final DateTime viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final VoidCallback? onBack;
  final void Function(DateTime month)? onMonthChanged;
  final void Function(int? day)? onDaySelected;
  final VoidCallback? onAddManual;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int _selectedFilterIndex = 0;

  static const List<String> _filterLabels = [
    'All Sessions',
    'Studio',
    'Gym',
    'Personal Training',
  ];

  int _daysInMonth() {
    return DateTime(widget.viewMonth.year, widget.viewMonth.month + 1, 0).day;
  }

  int _firstWeekdayOfMonth() {
    return DateTime(widget.viewMonth.year, widget.viewMonth.month, 1).weekday % 7;
  }

  bool _hasPresence(int day) {
    final d = DateTime(widget.viewMonth.year, widget.viewMonth.month, day);
    return widget.presenceByDay[d] ?? false;
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return now.year == widget.viewMonth.year &&
        now.month == widget.viewMonth.month &&
        now.day == day;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HistoryHeader(
              onBack: widget.onBack,
              isDark: isDark,
            ),
            HistoryFilterChips(
              labels: _filterLabels,
              selectedIndex: _selectedFilterIndex,
              isDark: isDark,
              onSelected: (i) => setState(() => _selectedFilterIndex = i),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    HistoryMonthNav(
                      viewMonth: widget.viewMonth,
                      theme: theme,
                      isDark: isDark,
                      onPrev: () {
                        final prev = DateTime(
                          widget.viewMonth.year,
                          widget.viewMonth.month - 1,
                        );
                        widget.onMonthChanged?.call(prev);
                      },
                      onNext: () {
                        final next = DateTime(
                          widget.viewMonth.year,
                          widget.viewMonth.month + 1,
                        );
                        widget.onMonthChanged?.call(next);
                      },
                    ),
                    const SizedBox(height: 16),
                    if (widget.loadingPresence)
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
                        viewMonth: widget.viewMonth,
                        daysInMonth: _daysInMonth(),
                        firstWeekday: _firstWeekdayOfMonth(),
                        hasPresence: _hasPresence,
                        isToday: _isToday,
                        selectedDay: widget.selectedDay,
                        theme: theme,
                        isDark: isDark,
                        onDayTap: (day) =>
                            widget.onDaySelected?.call(day),
                      ),
                    const SizedBox(height: 40),
                    HistoryDayDetailsSection(
                      viewMonth: widget.viewMonth,
                      selectedDay: widget.selectedDay,
                      dayPresences: widget.dayPresences,
                      loadingDayDetails: widget.loadingDayDetails,
                      places: widget.places,
                      theme: theme,
                      isDark: isDark,
                      monthName: historyMonthName(widget.viewMonth.month),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: widget.onAddManual != null
          ? Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: FloatingActionButton(
                onPressed: widget.onAddManual,
                child: const Icon(Icons.add, size: 28),
              ),
            )
          : null,
    );
  }
}

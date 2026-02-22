import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/places/entities/place.dart';
import '../../../domain/presence/entities/presence.dart';

String _historyMonthName(int month) {
  const names = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return names[month - 1];
}

/// Presence history calendar. Month view, filter chips, day details.
/// All data and loading state come from [CalendarBloc]; this screen only renders and dispatches events.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
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
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
            _HistoryHeader(
              onBack: widget.onBack,
              isDark: isDark,
            ),
            _HistoryFilterChips(
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
                    _HistoryMonthNav(
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
                      _HistoryCalendarGrid(
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
                    _HistoryDayDetailsSection(
                      viewMonth: widget.viewMonth,
                      selectedDay: widget.selectedDay,
                      dayPresences: widget.dayPresences,
                      loadingDayDetails: widget.loadingDayDetails,
                      places: widget.places,
                      theme: theme,
                      isDark: isDark,
                      monthName: _historyMonthName(widget.viewMonth.month),
                    ),
                  ],
                ),
              ),
            ),
            _HistoryBottomNav(isDark: isDark),
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

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader({this.onBack, required this.isDark});

  final VoidCallback? onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight)
            .withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                foregroundColor: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            )
          else
            const SizedBox(width: 48),
          Expanded(
            child: Text(
              'Presence History',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Sync – coming soon')),
              );
            },
            icon: const Icon(Icons.sync, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _HistoryFilterChips extends StatelessWidget {
  const _HistoryFilterChips({
    required this.labels,
    required this.selectedIndex,
    required this.isDark,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final bool isDark;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                labels[i],
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selected,
              onSelected: (_) => onSelected(i),
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _HistoryMonthNav extends StatelessWidget {
  const _HistoryMonthNav({
    required this.viewMonth,
    required this.theme,
    required this.isDark,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime viewMonth;
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final monthLabel = '${_historyMonthName(viewMonth.month)} ${viewMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
            foregroundColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          monthLabel,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        IconButton(
          onPressed: onNext,
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
            foregroundColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _HistoryCalendarGrid extends StatelessWidget {
  const _HistoryCalendarGrid({
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
                        letterSpacing: 0.2,
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
        const SizedBox(height: 8),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 7,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 1,
          children: [
            ...List.filled(firstWeekday, const SizedBox.shrink()),
            ...List.generate(daysInMonth, (i) {
              final day = i + 1;
              final hasP = hasPresence(day);
              final isSelected = selectedDay == day;
              final today = isToday(day);
              final highlight = today || isSelected;
              return GestureDetector(
                onTap: () => onDayTap(day),
                child: Container(
                  decoration: BoxDecoration(
                    color: highlight
                        ? AppColors.primary.withValues(
                            alpha: isDark ? 0.2 : 0.1,
                          )
                        : (isDark
                              ? const Color(0xFF334155).withValues(alpha: 0.4)
                              : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                    border: highlight
                        ? Border.all(color: AppColors.primary, width: 2)
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
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
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
              );
            }),
          ],
        ),
      ],
    );
  }
}

class _HistoryDayDetailsSection extends StatelessWidget {
  const _HistoryDayDetailsSection({
    required this.viewMonth,
    required this.selectedDay,
    required this.dayPresences,
    required this.loadingDayDetails,
    required this.places,
    required this.theme,
    required this.isDark,
    required this.monthName,
  });

  final DateTime viewMonth;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final List<Place> places;
  final ThemeData theme;
  final bool isDark;
  final String monthName;

  static IconData _iconForPlaceName(String name) {
    final n = name.toLowerCase();
    if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
    if (n.contains('yoga') || n.contains('studio')) return Icons.self_improvement;
    if (n.contains('office')) return Icons.apartment;
    return Icons.place;
  }

  static String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  @override
  Widget build(BuildContext context) {
    final day = selectedDay;

    if (day == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'DAY DETAILS',
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: 0.15,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF334155).withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'Tap a day on the calendar to see sessions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final hasPresence = dayPresences.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DAY DETAILS • $monthName $day',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.15,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
            ),
            if (hasPresence)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'PRESENT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else if (!loadingDayDetails)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'NO SESSIONS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (loadingDayDetails)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (dayPresences.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF334155).withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'No recorded sessions for this day',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          )
        else
          ...dayPresences.map((p) {
            Place? place;
            for (final pl in places) {
              if (pl.id == p.placeId) {
                place = pl;
                break;
              }
            }
            final placeName = place?.name ?? 'Unknown place';
            final timeStr = p.firstDetectedAt != null
                ? _formatTime(p.firstDetectedAt!)
                : 'Recorded';
            return _SessionTile(
              title: placeName,
              subtitle: timeStr,
              icon: _iconForPlaceName(placeName),
              isDark: isDark,
              onTap: () {},
            );
          }),
      ],
    );
  }
}

class _SessionTile extends StatelessWidget {
  const _SessionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isDark
          ? const Color(0xFF334155).withValues(alpha: 0.4)
          : const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryBottomNav extends StatelessWidget {
  const _HistoryBottomNav({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight)
            .withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _HistoryNavItem(
              icon: Icons.calendar_month,
              label: 'History',
              selected: true,
              isDark: isDark,
            ),
            _HistoryNavItem(
              icon: Icons.analytics_outlined,
              label: 'Stats',
              selected: false,
              isDark: isDark,
            ),
            _HistoryNavItem(
              icon: Icons.explore_outlined,
              label: 'Classes',
              selected: false,
              isDark: isDark,
            ),
            _HistoryNavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: false,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryNavItem extends StatelessWidget {
  const _HistoryNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: selected
              ? AppColors.primary
              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected
                ? AppColors.primary
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }
}

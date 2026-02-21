import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/places/entities/place.dart';
import '../../../domain/presence/entities/presence.dart';
import '../../../domain/presence/use_cases/get_aggregated_presence.dart';
import '../../../domain/presence/use_cases/get_presences_for_day.dart';

/// Presence history calendar (HTML: history_screen.html). Month view, filter chips, day details.
class HistoryScreen extends StatefulWidget {
  const HistoryScreen({
    super.key,
    this.places = const [],
    this.onBack,
    this.onAddManual,
    this.getAggregatedPresence,
    this.getPresencesForDay,
  });

  final List<Place> places;
  final VoidCallback? onBack;
  final VoidCallback? onAddManual;
  final GetAggregatedPresence? getAggregatedPresence;
  final GetPresencesForDay? getPresencesForDay;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late DateTime _viewMonth;
  int _selectedFilterIndex = 0;
  int? _selectedDay;
  Map<DateTime, bool> _presenceByDay = {};
  bool _loadingPresence = true;
  List<Presence> _dayPresences = [];
  bool _loadingDayDetails = false;

  static const List<String> _filterLabels = [
    'All Sessions',
    'Studio',
    'Gym',
    'Personal Training',
  ];

  @override
  void initState() {
    super.initState();
    _viewMonth = DateTime(DateTime.now().year, DateTime.now().month);
    _loadPresence();
  }

  Future<void> _loadPresence() async {
    final getPresence = widget.getAggregatedPresence;
    if (getPresence == null) {
      if (mounted) setState(() => _loadingPresence = false);
      return;
    }
    setState(() => _loadingPresence = true);
    final start = DateTime(_viewMonth.year, _viewMonth.month, 1);
    final end = DateTime(_viewMonth.year, _viewMonth.month + 1, 0);
    final map = await getPresence.call(start, end);
    if (mounted) {
      setState(() {
        _presenceByDay = map;
        _loadingPresence = false;
      });
    }
  }

  int _daysInMonth() {
    return DateTime(_viewMonth.year, _viewMonth.month + 1, 0).day;
  }

  int _firstWeekdayOfMonth() {
    return DateTime(_viewMonth.year, _viewMonth.month, 1).weekday % 7; // Sun=0
  }

  bool _hasPresence(int day) {
    final d = DateTime(_viewMonth.year, _viewMonth.month, day);
    return _presenceByDay[d] ?? false;
  }

  bool _isToday(int day) {
    final now = DateTime.now();
    return now.year == _viewMonth.year && now.month == _viewMonth.month && now.day == day;
  }

  Future<void> _loadDayDetails(int day) async {
    final getPresences = widget.getPresencesForDay;
    if (getPresences == null) return;
    setState(() => _loadingDayDetails = true);
    final date = DateTime(_viewMonth.year, _viewMonth.month, day);
    final list = await getPresences.call(date);
    if (mounted) {
      setState(() {
        _dayPresences = list;
        _loadingDayDetails = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildFilterChips(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  children: [
                    _buildMonthNav(context, theme, isDark),
                    const SizedBox(height: 16),
                    if (_loadingPresence)
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
                      _buildCalendarGrid(theme, isDark),
                    const SizedBox(height: 40),
                    _buildDayDetailsSection(theme, isDark),
                  ],
                ),
              ),
            ),
            _buildBottomNav(context, isDark),
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

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight).withOpacity(0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (widget.onBack != null)
            IconButton(
              onPressed: widget.onBack,
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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

  Widget _buildFilterChips(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: List.generate(
          _filterLabels.length,
          (i) {
            final selected = i == _selectedFilterIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(_filterLabels[i], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                selected: selected,
                onSelected: (_) => setState(() => _selectedFilterIndex = i),
                backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569)),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMonthNav(BuildContext context, ThemeData theme, bool isDark) {
    final monthLabel = '${_monthName(_viewMonth.month)} ${_viewMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _viewMonth = DateTime(_viewMonth.year, _viewMonth.month - 1);
              _selectedDay = null;
              _dayPresences = [];
            });
            _loadPresence();
          },
          style: IconButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFF1F5F9),
            foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
          onPressed: () {
            setState(() {
              _viewMonth = DateTime(_viewMonth.year, _viewMonth.month + 1);
              _selectedDay = null;
              _dayPresences = [];
            });
            _loadPresence();
          },
          style: IconButton.styleFrom(
            backgroundColor: isDark ? const Color(0xFF334155).withOpacity(0.5) : const Color(0xFFF1F5F9),
            foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }

  String _monthName(int month) {
    const names = ['January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'];
    return names[month - 1];
  }

  Widget _buildCalendarGrid(ThemeData theme, bool isDark) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final firstWeekday = _firstWeekdayOfMonth();
    final daysInMonth = _daysInMonth();

    return Column(
      children: [
        Row(
          children: weekdays.map((d) => Expanded(
            child: Center(
              child: Text(
                d,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                  color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
                ),
              ),
            ),
          )).toList(),
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
              final hasPresence = _hasPresence(day);
              final isSelected = _selectedDay == day;
              final today = _isToday(day);
              final highlight = today || isSelected;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedDay = day);
                  _loadDayDetails(day);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: highlight
                        ? AppColors.primary.withOpacity(isDark ? 0.2 : 0.1)
                        : (isDark ? const Color(0xFF334155).withOpacity(0.4) : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(12),
                    border: highlight ? Border.all(color: AppColors.primary, width: 2) : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: highlight ? FontWeight.bold : FontWeight.w500,
                          color: highlight ? AppColors.primary : (isDark ? Colors.white : const Color(0xFF0F172A)),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: hasPresence ? AppColors.primary : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                          border: hasPresence ? null : Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFF94A3B8)),
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

  Widget _buildDayDetailsSection(ThemeData theme, bool isDark) {
    final day = _selectedDay;
    final monthLabel = _monthName(_viewMonth.month);

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
              color: isDark ? const Color(0xFF334155).withOpacity(0.3) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'Tap a day on the calendar to see sessions',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      );
    }

    final hasPresence = _dayPresences.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'DAY DETAILS • $monthLabel $day',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.15,
                color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
              ),
            ),
            if (hasPresence)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
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
            else if (!_loadingDayDetails)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'NO SESSIONS',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_loadingDayDetails)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          )
        else if (_dayPresences.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF334155).withOpacity(0.3) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                'No recorded sessions for this day',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ),
          )
        else
          ..._dayPresences.map((p) {
            Place? place;
            for (final pl in widget.places) {
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

  static IconData _iconForPlaceName(String name) {
    final n = name.toLowerCase();
    if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
    if (n.contains('yoga') || n.contains('studio')) return Icons.self_improvement;
    if (n.contains('office')) return Icons.apartment;
    return Icons.place;
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight).withOpacity(0.95),
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
            _HistoryNavItem(icon: Icons.calendar_month, label: 'History', selected: true, isDark: isDark),
            _HistoryNavItem(icon: Icons.analytics_outlined, label: 'Stats', selected: false, isDark: isDark),
            _HistoryNavItem(icon: Icons.explore_outlined, label: 'Classes', selected: false, isDark: isDark),
            _HistoryNavItem(icon: Icons.person_outline, label: 'Profile', selected: false, isDark: isDark),
          ],
        ),
      ),
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
      color: isDark ? const Color(0xFF334155).withOpacity(0.4) : const Color(0xFFF1F5F9),
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
                  color: AppColors.primary.withOpacity(0.1),
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
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ],
          ),
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
          color: selected ? AppColors.primary : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected ? AppColors.primary : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/manual_attendance/widgets/manual_attendance_place_row.dart';

/// Manual presence override (HTML: manual_attendance.html). Date + list of places with toggles.
/// Toggles reflect that day's presence when [initialPresenceByPlaceId] or [getPresenceForDate] is provided.
class ManualAttendancePage extends StatefulWidget {
  const ManualAttendancePage({
    super.key,
    required this.places,
    this.initialDate,
    this.initialPresenceByPlaceId,
    this.getPresenceForDate,
    this.onApply,
    this.onCancel,
  });

  final List<Place> places;
  final DateTime? initialDate;
  /// Presence for [initialDate] per place id (true = present). If null and [getPresenceForDate] is set, presence is loaded for the initial date.
  final Map<String, bool>? initialPresenceByPlaceId;
  /// When the user changes the date, toggles are updated from this. Also used for initial date when [initialPresenceByPlaceId] is null.
  final Future<Map<String, bool>> Function(DateTime date)? getPresenceForDate;
  final void Function(DateTime date, Map<String, bool> placePresence)? onApply;
  final VoidCallback? onCancel;

  @override
  State<ManualAttendancePage> createState() => _ManualAttendancePageState();
}

class _ManualAttendancePageState extends State<ManualAttendancePage> {
  late DateTime _selectedDate;
  late Map<String, bool> _presenceByPlaceId;
  bool _loadingPresence = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _presenceByPlaceId = _buildPresenceMap(widget.initialPresenceByPlaceId);
    if (widget.initialPresenceByPlaceId == null &&
        widget.getPresenceForDate != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadPresenceForDate(_selectedDate));
    }
  }

  Map<String, bool> _buildPresenceMap(Map<String, bool>? source) {
    final map = {for (final p in widget.places) p.id: false};
    if (source != null) {
      for (final e in source.entries) {
        if (map.containsKey(e.key)) map[e.key] = e.value;
      }
    }
    return map;
  }

  Future<void> _loadPresenceForDate(DateTime date) async {
    final getPresence = widget.getPresenceForDate;
    if (getPresence == null || !mounted) return;
    setState(() => _loadingPresence = true);
    try {
      final map = await getPresence(date);
      if (mounted) {
        setState(() {
          _presenceByPlaceId = _buildPresenceMap(map);
          _loadingPresence = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingPresence = false);
      }
    }
  }

  static IconData _iconForPlace(Place place) {
    final n = place.name.toLowerCase();
    if (n.contains('office') || n.contains('corporate')) {
      return Icons.corporate_fare;
    }
    if (n.contains('gym') || n.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (n.contains('cowork') || n.contains('desk')) {
      return Icons.desk;
    }
    if (n.contains('client') || n.contains('meeting')) {
      return Icons.meeting_room;
    }
    return Icons.place;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateStr = _formatDate(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF24303F) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                        color:
                            (isDark
                                    ? const Color(0xFF334155)
                                    : const Color(0xFFF1F5F9))
                                .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate,
                              firstDate: DateTime(_selectedDate.year - 1),
                              lastDate: DateTime(_selectedDate.year + 1),
                            );
                            if (picked != null && mounted) {
                              setState(() => _selectedDate = picked);
                              await _loadPresenceForDate(picked);
                            }
                          },
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
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                children: widget.places.map((place) {
                  final present = _presenceByPlaceId[place.id] ?? false;
                  return ManualAttendancePlaceRow(
                    place: place,
                    present: present,
                    isDark: isDark,
                    icon: _iconForPlace(place),
                    onChanged: (v) =>
                        setState(() => _presenceByPlaceId[place.id] = v),
                    enabled: !_loadingPresence,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_sync,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                ),
                const SizedBox(width: 8),
                Text(
                  'SYNCS WITH GOOGLE CALENDAR',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        widget.onApply?.call(
                          _selectedDate,
                          Map.from(_presenceByPlaceId),
                        );
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Apply Changes',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: TextButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                      ),
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

  String _formatDate(DateTime d) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final weekday = days[d.weekday - 1];
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '$weekday, ${months[d.month - 1]} ${d.day}';
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/places/entities/place.dart';

/// Manual presence override (HTML: manual_attendance.html). Date + list of places with toggles.
class ManualAttendanceScreen extends StatefulWidget {
  const ManualAttendanceScreen({
    super.key,
    required this.places,
    this.initialDate,
    this.onApply,
    this.onCancel,
  });

  final List<Place> places;
  final DateTime? initialDate;
  final void Function(DateTime date, Map<String, bool> placePresence)? onApply;
  final VoidCallback? onCancel;

  @override
  State<ManualAttendanceScreen> createState() => _ManualAttendanceScreenState();
}

class _ManualAttendanceScreenState extends State<ManualAttendanceScreen> {
  late DateTime _selectedDate;
  late Map<String, bool> _presenceByPlaceId;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now();
    _presenceByPlaceId = {for (final p in widget.places) p.id: false};
  }

  static IconData _iconForPlace(Place place) {
    final n = place.name.toLowerCase();
    if (n.contains('office') || n.contains('corporate')) return Icons.corporate_fare;
    if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
    if (n.contains('cowork') || n.contains('desk')) return Icons.desk;
    if (n.contains('client') || n.contains('meeting')) return Icons.meeting_room;
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
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
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
                  color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
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
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Manual Presence Override',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Material(
                        color: (isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)).withOpacity(0.8),
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
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: widget.places.map((place) {
                  final present = _presenceByPlaceId[place.id] ?? false;
                  return _ManualPlaceRow(
                    place: place,
                    present: present,
                    isDark: isDark,
                    icon: _iconForPlace(place),
                    onChanged: (v) => setState(() => _presenceByPlaceId[place.id] = v),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_sync, size: 14, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                const SizedBox(width: 8),
                Text(
                  'SYNCS WITH GOOGLE CALENDAR',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
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
                        widget.onApply?.call(_selectedDate, Map.from(_presenceByPlaceId));
                        Navigator.of(context).pop();
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Apply Changes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
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
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    final weekday = days[d.weekday - 1];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '$weekday, ${months[d.month - 1]} ${d.day}';
  }
}

class _ManualPlaceRow extends StatelessWidget {
  const _ManualPlaceRow({
    required this.place,
    required this.present,
    required this.isDark,
    required this.icon,
    required this.onChanged,
  });

  final Place place;
  final bool present;
  final bool isDark;
  final IconData icon;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF334155).withOpacity(0.4) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0)),
            ),
            child: Icon(icon, size: 24, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      place.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.sync, size: 16, color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  place.address.isNotEmpty ? place.address : 'No address',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? const Color(0xFF64748B) : const Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: present,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

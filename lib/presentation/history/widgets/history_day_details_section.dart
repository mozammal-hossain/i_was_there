import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/domain/presence/entities/presence.dart';
import 'package:i_was_there/presentation/history/widgets/history_session_tile.dart';

class HistoryDayDetailsSection extends StatelessWidget {
  const HistoryDayDetailsSection({
    super.key,
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
            return HistorySessionTile(
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

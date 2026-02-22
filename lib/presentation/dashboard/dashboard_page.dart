import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_bottom_nav.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_place_card.dart';

/// Places dashboard: list of tracked places with weekly attendance dots (PRD R9, R10).
class DashboardPage extends StatelessWidget {
  const DashboardPage({
    super.key,
    required this.places,
    required this.onAddPlace,
    required this.onPlaceTap,
    this.onManualOverride,
    this.currentNavIndex = 0,
    this.onNavTap,
    this.placesOnlyNav = false,
  });

  final List<Place> places;
  final VoidCallback onAddPlace;
  final void Function(Place place) onPlaceTap;
  final VoidCallback? onManualOverride;
  final int currentNavIndex;
  final void Function(int index)? onNavTap;

  /// When true, bottom nav is hidden (for use inside Places feature tab; main shell has its own nav).
  final bool placesOnlyNav;

  static const List<DashboardNavItem> _navItems = [
    DashboardNavItem(Icons.calendar_today, 'Calendar'),
    DashboardNavItem(Icons.map_outlined, 'Map'),
    DashboardNavItem(Icons.history, 'History'),
    DashboardNavItem(Icons.settings_outlined, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Places',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                'Weekly Attendance',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? const Color(0xFF94A3B8)
                                      : const Color(0xFF64748B),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (onManualOverride != null) ...[
                                const SizedBox(width: 12),
                                TextButton(
                                  onPressed: onManualOverride,
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                    'Override',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      child: Icon(
                        Icons.person_outline,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 8, 24, 12),
                child: Text(
                  'TRACKED STUDIOS',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.1,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final place = places[index];
                  return DashboardPlaceCard(
                    place: place,
                    isDark: isDark,
                    onTap: () => onPlaceTap(place),
                  );
                }, childCount: places.length),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: FloatingActionButton(
          onPressed: onAddPlace,
          child: const Icon(Icons.add, size: 28),
        ),
      ),
      bottomNavigationBar: placesOnlyNav
          ? null
          : DashboardBottomNav(
              currentIndex: currentNavIndex,
              items: _navItems,
              onTap: onNavTap ?? (_) {},
              isDark: isDark,
            ),
    );
  }
}

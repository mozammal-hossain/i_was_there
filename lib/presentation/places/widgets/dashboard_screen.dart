import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/places/entities/place.dart';

/// Places dashboard: list of tracked places with weekly attendance dots (PRD R9, R10).
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
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

  /// When true, bottom nav shows only "Places" and "Map" (for use inside Places feature tab).
  final bool placesOnlyNav;

  static const List<_NavItem> _navItems = [
    _NavItem(Icons.calendar_today, 'Calendar'),
    _NavItem(Icons.map_outlined, 'Map'),
    _NavItem(Icons.history, 'History'),
    _NavItem(Icons.settings_outlined, 'Settings'),
  ];

  static const List<_NavItem> _placesNavItems = [
    _NavItem(Icons.list_alt, 'Places'),
    _NavItem(Icons.map_outlined, 'Map'),
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
                  return _PlaceCard(
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
      bottomNavigationBar: _BottomNav(
        currentIndex: currentNavIndex,
        items: placesOnlyNav ? _placesNavItems : _navItems,
        onTap: onNavTap ?? (_) {},
        isDark: isDark,
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  const _PlaceCard({
    required this.place,
    required this.isDark,
    required this.onTap,
  });

  final Place place;
  final bool isDark;
  final VoidCallback onTap;

  static IconData _iconForPlace(Place place) {
    final n = place.name.toLowerCase();
    if (n.contains('gym') || n.contains('fitness')) return Icons.fitness_center;
    if (n.contains('yoga') || n.contains('studio'))
      return Icons.self_improvement;
    return Icons.apartment;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(isDark ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _iconForPlace(place),
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          place.syncStatus.label,
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
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5E1),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const SizedBox(width: 4),
                  ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].asMap().entries.map((
                    e,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(7, (i) {
                  final present = place.weeklyPresence[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: present
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.neutralDotDark
                                  : AppColors.neutralDot),
                        boxShadow: present
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.isDark,
  });

  final int currentIndex;
  final List<_NavItem> items;
  final void Function(int) onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : Colors.white).withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 16, 40, 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;
              return InkWell(
                onTap: () => onTap(i),
                borderRadius: BorderRadius.circular(24),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        size: 28,
                        color: selected
                            ? AppColors.primary
                            : (isDark
                                  ? const Color(0xFF475569)
                                  : const Color(0xFF94A3B8)),
                        fill: selected ? 1.0 : 0.0,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 11,
                          color: selected
                              ? AppColors.primary
                              : (isDark
                                    ? const Color(0xFF475569)
                                    : const Color(0xFF94A3B8)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_bottom_nav.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_page_header.dart';
import 'package:i_was_there/presentation/dashboard/widgets/dashboard_place_list_section.dart';

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
              child: DashboardPageHeader(
                theme: theme,
                isDark: isDark,
                onManualOverride: onManualOverride,
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
            DashboardPlaceListSection(
              places: places,
              isDark: isDark,
              onPlaceTap: onPlaceTap,
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: FloatingActionButton.extended(
          elevation: 5,
          onPressed: onAddPlace,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_location_alt, color: Colors.white),
          label: const Text(
            'Add Location',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

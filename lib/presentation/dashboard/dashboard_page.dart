import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final navItems = [
      DashboardNavItem(Icons.calendar_today, l10n.calendar),
      DashboardNavItem(Icons.map_outlined, l10n.map),
      DashboardNavItem(Icons.history, l10n.history),
      DashboardNavItem(Icons.settings_outlined, l10n.settings),
    ];

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
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSize.spacingXl,
                  AppSize.spacingM,
                  AppSize.spacingXl,
                  AppSize.spacingM3,
                ),
                child: Text(
                  l10n.trackedStudios,
                  style: TextStyle(
                    fontSize: AppSize.fontCaption2,
                    fontWeight: FontWeight.bold,
                    letterSpacing: AppSize.letterSpacingTight,
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
            const SliverToBoxAdapter(
              child: SizedBox(height: AppSize.spacingHeroBottom),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: AppSize.spacingL2),
        child: FloatingActionButton.extended(
          heroTag: 'dashboard_fab',
          elevation: AppSize.elevationFabExtended,
          onPressed: onAddPlace,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.add_location_alt, color: Colors.white),
          label: Text(
            l10n.addLocation,
            style: TextStyle(
              fontSize: AppSize.fontBodyLg,
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
              items: navItems,
              onTap: onNavTap ?? (_) {},
              isDark: isDark,
            ),
    );
  }
}

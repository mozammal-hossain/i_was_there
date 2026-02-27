import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import 'calendar_feature.dart';
import 'places_feature.dart';
import 'settings_feature.dart';

/// Main shell after onboarding: bottom nav with Places | Calendar | Settings.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: IndexedStack(
        index: _tabIndex,
        children: [
          const PlacesFeature(),
          const CalendarFeature(),
          const SettingsFeature(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: (isDark ? AppColors.bgDarkGray : Colors.white).withValues(
            alpha: 0.95,
          ),
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSize.spacingXl,
              vertical: AppSize.spacingM3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabItem(
                  icon: Icons.place_outlined,
                  label: AppLocalizations.of(context)!.places,
                  selected: _tabIndex == 0,
                  isDark: isDark,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _TabItem(
                  icon: Icons.calendar_today_outlined,
                  label: AppLocalizations.of(context)!.calendar,
                  selected: _tabIndex == 1,
                  isDark: isDark,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
                _TabItem(
                  icon: Icons.settings_outlined,
                  label: AppLocalizations.of(context)!.settings,
                  selected: _tabIndex == 2,
                  isDark: isDark,
                  onTap: () => setState(() => _tabIndex = 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.radiusCard),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSize.spacingL,
          vertical: AppSize.spacingM,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppSize.iconL2,
              color: selected
                  ? AppColors.primary
                  : (isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: AppSize.spacingS),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSize.fontSmall,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : (isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

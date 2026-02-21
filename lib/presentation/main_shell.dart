import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../data/database/app_database.dart';
import 'calendar/calendar_feature.dart';
import 'places/places_feature.dart';
import 'settings/settings_feature.dart';

/// Main shell after onboarding: bottom nav with Places | Calendar | Settings.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.database});

  final AppDatabase database;

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
          PlacesFeature(database: widget.database),
          CalendarFeature(database: widget.database),
          SettingsFeature(database: widget.database),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: (isDark ? AppColors.bgDarkGray : Colors.white).withOpacity(0.95),
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _TabItem(
                  icon: Icons.place_outlined,
                  label: 'Places',
                  selected: _tabIndex == 0,
                  isDark: isDark,
                  onTap: () => setState(() => _tabIndex = 0),
                ),
                _TabItem(
                  icon: Icons.calendar_today_outlined,
                  label: 'Calendar',
                  selected: _tabIndex == 1,
                  isDark: isDark,
                  onTap: () => setState(() => _tabIndex = 1),
                ),
                _TabItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
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
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 26,
              color: selected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? AppColors.primary
                    : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

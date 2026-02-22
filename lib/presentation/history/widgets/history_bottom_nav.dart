import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/history/widgets/history_nav_item.dart';

class HistoryBottomNav extends StatelessWidget {
  const HistoryBottomNav({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight)
            .withValues(alpha: 0.95),
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
            HistoryNavItem(
              icon: Icons.calendar_month,
              label: 'History',
              selected: true,
              isDark: isDark,
            ),
            HistoryNavItem(
              icon: Icons.analytics_outlined,
              label: 'Stats',
              selected: false,
              isDark: isDark,
            ),
            HistoryNavItem(
              icon: Icons.explore_outlined,
              label: 'Classes',
              selected: false,
              isDark: isDark,
            ),
            HistoryNavItem(
              icon: Icons.person_outline,
              label: 'Profile',
              selected: false,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

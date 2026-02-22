import 'package:flutter/material.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_nav_icon.dart';

class SettingsBottomNav extends StatelessWidget {
  const SettingsBottomNav({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 12, 32, 24),
      decoration: BoxDecoration(
        color: (isDark ? const Color(0xFF1E1E1E) : Colors.white).withValues(
          alpha: 0.8,
        ),
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
            SettingsNavIcon(
              icon: Icons.map_outlined,
              label: 'Places',
              isSelected: false,
              isDark: isDark,
              onTap: () {},
            ),
            SettingsNavIcon(
              icon: Icons.bar_chart,
              label: 'Activity',
              isSelected: false,
              isDark: isDark,
              onTap: () {},
            ),
            SettingsNavIcon(
              icon: Icons.settings,
              label: 'Settings',
              isSelected: true,
              isDark: isDark,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

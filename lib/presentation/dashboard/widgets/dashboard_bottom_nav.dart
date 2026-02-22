import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class DashboardNavItem {
  const DashboardNavItem(this.icon, this.label);
  final IconData icon;
  final String label;
}

class DashboardBottomNav extends StatelessWidget {
  const DashboardBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
    required this.isDark,
  });

  final int currentIndex;
  final List<DashboardNavItem> items;
  final void Function(int) onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : Colors.white).withValues(
          alpha: 0.9,
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

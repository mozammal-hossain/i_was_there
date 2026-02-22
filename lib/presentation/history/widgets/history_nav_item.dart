import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class HistoryNavItem extends StatelessWidget {
  const HistoryNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 24,
          color: selected
              ? AppColors.primary
              : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
            color: selected
                ? AppColors.primary
                : (isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8)),
          ),
        ),
      ],
    );
  }
}

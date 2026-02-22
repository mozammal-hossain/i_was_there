import 'package:flutter/material.dart';
import 'package:i_was_there/presentation/history/utils/history_utils.dart';

class HistoryMonthNav extends StatelessWidget {
  const HistoryMonthNav({
    super.key,
    required this.viewMonth,
    required this.theme,
    required this.isDark,
    required this.onPrev,
    required this.onNext,
  });

  final DateTime viewMonth;
  final ThemeData theme;
  final bool isDark;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final monthLabel = '${historyMonthName(viewMonth.month)} ${viewMonth.year}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: onPrev,
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
            foregroundColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
          icon: const Icon(Icons.chevron_left),
        ),
        Text(
          monthLabel,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        IconButton(
          onPressed: onNext,
          style: IconButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF334155).withValues(alpha: 0.5)
                : const Color(0xFFF1F5F9),
            foregroundColor: isDark
                ? const Color(0xFF94A3B8)
                : const Color(0xFF64748B),
          ),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

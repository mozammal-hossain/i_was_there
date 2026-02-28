import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class HistoryFilterChips extends StatelessWidget {
  const HistoryFilterChips({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.isDark,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final bool isDark;
  final void Function(int) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSize.spacingL,
        AppSize.spacingM,
        AppSize.spacingL,
        AppSize.spacingM,
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: AppSize.spacingM),
            child: FilterChip(
              label: Text(
                labels[i],
                style: const TextStyle(
                  fontSize: AppSize.fontBodySm,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: selected,
              onSelected: (_) => onSelected(i),
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: selected
                    ? Colors.white
                    : (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF475569)),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSize.spacingL2,
                vertical: AppSize.spacingM3,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusPill),
              ),
            ),
          );
        }),
      ),
    );
  }
}

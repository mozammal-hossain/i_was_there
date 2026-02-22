import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'package:go_router/go_router.dart';

class AddEditPlaceHeader extends StatelessWidget {
  const AddEditPlaceHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.backgroundDark : AppColors.bgWarmLight)
            .withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.chevron_left,
              size: 24,
              color: AppColors.primary,
            ),
            label: const Text(
              'Back',
              style: TextStyle(color: AppColors.primary, fontSize: 17),
            ),
          ),
          Text(
            'Tracked Place',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.primary, fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

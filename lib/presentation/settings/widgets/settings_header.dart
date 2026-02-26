import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({super.key, this.onBack, required this.isDark});

  final VoidCallback? onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingL,
        vertical: AppSize.spacingM3,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight)
            .withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null)
            TextButton.icon(
              onPressed: onBack,
              icon: Icon(
                Icons.chevron_left,
                size: AppSize.iconNav,
                color: AppColors.primary,
              ),
              label: Text(
                'Back',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: AppSize.fontTitle,
                ),
              ),
            ),
          Expanded(
            child: Text(
              'Calendar Sync',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.fontTitle,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          if (onBack != null)
            const SizedBox(width: AppSize.spacingXl8)
          else
            const SizedBox(width: AppSize.avatarLg),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class HistorySessionTile extends StatelessWidget {
  const HistorySessionTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isDark
          ? const Color(0xFF334155).withValues(alpha: 0.4)
          : const Color(0xFFF1F5F9),
      borderRadius: BorderRadius.circular(AppSize.radiusCard),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSize.spacingL),
          child: Row(
            children: [
              Container(
                width: AppSize.avatarMd,
                height: AppSize.avatarMd,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: AppSize.iconM2,
                ),
              ),
              const SizedBox(width: AppSize.spacingL),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: AppSize.fontSmall,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

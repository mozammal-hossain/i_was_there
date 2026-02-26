import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class SettingsSyncSection extends StatelessWidget {
  const SettingsSyncSection({
    super.key,
    required this.syncEnabled,
    required this.loading,
    required this.theme,
    required this.isDark,
    required this.onChanged,
  });

  final bool syncEnabled;
  final bool loading;
  final ThemeData theme;
  final bool isDark;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSize.spacingL2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.radiusXl),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync with Google Calendar',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: AppSize.spacingS),
                    Text(
                      'Automatic attendance logging',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        fontSize: AppSize.fontBody2,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: syncEnabled,
                onChanged: loading ? null : onChanged,
                activeTrackColor: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSize.spacingM3),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.security,
              size: AppSize.iconS2,
              color: AppColors.primary,
            ),
            const SizedBox(width: AppSize.spacingM),
            Expanded(
              child: Text(
                'One-way sync: We only add events to your calendar. We never read or delete your existing data.',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                  fontSize: AppSize.fontBody2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

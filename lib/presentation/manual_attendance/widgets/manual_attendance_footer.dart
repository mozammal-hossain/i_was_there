import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

/// Manual attendance sheet footer: sync label and Apply / Cancel buttons.
class ManualAttendanceFooter extends StatelessWidget {
  const ManualAttendanceFooter({
    super.key,
    required this.theme,
    required this.isDark,
    required this.onApply,
    required this.onCancel,
  });

  final ThemeData theme;
  final bool isDark;
  final VoidCallback onApply;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AppSize.spacingXl),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_sync,
              size: AppSize.iconXs,
              color: isDark
                  ? const Color(0xFF64748B)
                  : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: AppSize.spacingM),
            Text(
              'SYNCS WITH GOOGLE CALENDAR',
              style: theme.textTheme.labelSmall?.copyWith(
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                letterSpacing: AppSize.letterSpacingLg,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSize.spacingXl3,
            AppSize.spacingL,
            AppSize.spacingXl3,
            AppSize.spacingXl5,
          ),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: AppSize.buttonHeight,
                child: FilledButton(
                  onPressed: onApply,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSize.radiusXl),
                    ),
                  ),
                  child: const Text(
                    'Apply Changes',
                    style: TextStyle(
                      fontSize: AppSize.fontTitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.spacingM3),
              SizedBox(
                width: double.infinity,
                height: AppSize.buttonHeightSm,
                child: TextButton(
                  onPressed: onCancel,
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: AppSize.fontBodyLg,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class AddEditPlaceSaveSection extends StatelessWidget {
  const AddEditPlaceSaveSection({
    super.key,
    required this.isDark,
    required this.onSave,
  });

  final bool isDark;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSize.buttonHeight,
          child: FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusL),
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.saveChanges,
              style: TextStyle(
                fontSize: AppSize.fontTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSize.spacingL),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync,
              size: AppSize.iconXs,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: AppSize.spacingS2),
            Flexible(
              child: Text(
                AppLocalizations.of(context)!.updatesSyncWithGoogleCalendar,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
                      ? const Color(0xFF64748B)
                      : const Color(0xFF94A3B8),
                  fontSize: AppSize.fontSmall,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

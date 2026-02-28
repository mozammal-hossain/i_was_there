import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class BackgroundLocationFooter extends StatelessWidget {
  const BackgroundLocationFooter({
    super.key,
    this.onOpenSettings,
    this.onLater,
    required this.theme,
    required this.isDark,
  });

  final VoidCallback? onOpenSettings;
  final VoidCallback? onLater;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSize.spacingL,
        AppSize.spacingL,
        AppSize.spacingL,
        AppSize.spacingXl,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: AppSize.buttonHeight,
              child: FilledButton.icon(
                onPressed: onOpenSettings ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.openingSystemSettings),
                        ),
                      );
                    },
                icon: const Icon(Icons.open_in_new, size: AppSize.iconM),
                label: Text(
                  AppLocalizations.of(context)!.openSettings,
                  style: TextStyle(
                    fontSize: AppSize.fontTitle,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusL),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSize.spacingM3),
            TextButton(
              onPressed: onLater ?? () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context)!.illDoThisLater,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: AppSize.spacingL),
            Text(
              AppLocalizations.of(context)!.backgroundLocationFooterPrivacy,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                fontSize: AppSize.fontCaption2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

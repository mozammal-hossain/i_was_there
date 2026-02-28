import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class SettingsSyncNowButton extends StatelessWidget {
  const SettingsSyncNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: AppSize.buttonHeight,
      child: FilledButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.syncing)),
          );
        },
        icon: const Icon(Icons.sync, size: AppSize.iconM),
        label: Text(
          AppLocalizations.of(context)!.syncNow,
          style: TextStyle(
            fontSize: AppSize.fontBodyLg,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSize.radiusXl),
          ),
        ),
      ),
    );
  }
}

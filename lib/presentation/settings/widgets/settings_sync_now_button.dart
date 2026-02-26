import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

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
            const SnackBar(content: Text('Syncing…')),
          );
        },
        icon: const Icon(Icons.sync, size: AppSize.iconM),
        label: const Text(
          'Sync Now',
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

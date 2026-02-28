import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class AddEditPlaceGeofenceInfo extends StatelessWidget {
  const AddEditPlaceGeofenceInfo({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSize.spacingL),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSize.radiusL),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: AppSize.iconM,
          ),
          const SizedBox(width: AppSize.spacingM3),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.geoFenceDescription,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                height: AppSize.lineHeightRelaxed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

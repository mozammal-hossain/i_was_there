import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

class AddEditPlaceHeader extends StatelessWidget {
  const AddEditPlaceHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSize.spacingM,
        bottom: AppSize.spacingM3,
        left: AppSize.spacingL,
        right: AppSize.spacingL,
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
              size: AppSize.iconL,
              color: AppColors.primary,
            ),
            label: Text(
              AppLocalizations.of(context)!.back,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppSize.fontTitle,
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.trackedPlace,
            style: TextStyle(
              fontSize: AppSize.fontTitle,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppSize.fontTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

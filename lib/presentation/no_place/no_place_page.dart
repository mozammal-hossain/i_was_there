import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';

/// Shown when the user has no tracked places (PRD R1). Encourages adding the first place.
class NoPlacePage extends StatelessWidget {
  const NoPlacePage({super.key, required this.onAddPlace});

  final VoidCallback onAddPlace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.place_outlined,
                size: AppSize.iconXl4,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: AppSize.spacingXl),
              Text(
                AppLocalizations.of(context)!.noPlacesYet,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: AppSize.spacingM),
              Text(
                AppLocalizations.of(context)!.addPlaceToStart,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              const Spacer(flex: 2),
              FilledButton.icon(
                onPressed: onAddPlace,
                icon: const Icon(Icons.add, size: AppSize.iconM2),
                label: Text(AppLocalizations.of(context)!.addYourFirstPlace),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSize.spacingXl,
                    vertical: AppSize.spacingL,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSize.radiusL),
                  ),
                ),
              ),
              const SizedBox(height: AppSize.spacingXl5),
            ],
          ),
        ),
      ),
    );
  }
}

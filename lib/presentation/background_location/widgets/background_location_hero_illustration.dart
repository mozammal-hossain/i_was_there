import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class BackgroundLocationHeroIllustration extends StatelessWidget {
  const BackgroundLocationHeroIllustration({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: AppSize.heroIllustrationMaxHeight),
      padding: const EdgeInsets.all(AppSize.spacingXl),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSize.radiusXl),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppSize.spacingL),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.radiusL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: AppSize.spacingL,
                offset: const Offset(0, AppSize.spacingS),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _HeroLocationBarRow(isDark: isDark),
              const SizedBox(height: AppSize.spacingM3),
              _HeroSkeletonBar(isDark: isDark, fullWidth: true),
              const SizedBox(height: AppSize.spacingM),
              _HeroSkeletonBar(isDark: isDark, fullWidth: false),
              const SizedBox(height: AppSize.spacingL),
              _HeroOptionRow(
                isSelected: true,
                label: AppLocalizations.of(context)!.allowAllTheTime,
                isDark: isDark,
              ),
              const SizedBox(height: AppSize.spacingM),
              _HeroOptionRow(
                isSelected: false,
                label: null,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroLocationBarRow extends StatelessWidget {
  const _HeroLocationBarRow({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, size: AppSize.iconS, color: AppColors.primary),
        const SizedBox(width: AppSize.spacingM),
        Container(
          height: AppSize.dotSm,
          width: AppSize.spacingXl8,
          decoration: BoxDecoration(
            color: isDark
                ? const Color(0xFF475569)
                : const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(AppSize.radiusM),
          ),
        ),
      ],
    );
  }
}

class _HeroSkeletonBar extends StatelessWidget {
  const _HeroSkeletonBar({required this.isDark, required this.fullWidth});

  final bool isDark;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSize.dotMd,
      width: fullWidth ? double.infinity : AppSize.spacingHeroBottom,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF475569)
            : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(AppSize.radiusM),
      ),
    );
  }
}

class _HeroOptionRow extends StatelessWidget {
  const _HeroOptionRow({
    required this.isSelected,
    required this.label,
    required this.isDark,
  });

  final bool isSelected;
  final String? label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSize.iconS,
          height: AppSize.iconS,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
              width: isSelected ? AppSize.spacingXs : 1,
            ),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: AppSize.spacingS2,
                    height: AppSize.spacingS2,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSize.spacingM3),
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: AppSize.fontSmall,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          )
        else
          Container(
            height: AppSize.dotSm,
            width: AppSize.spacingXl9,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFFE2E8F0),
              borderRadius: BorderRadius.circular(AppSize.radiusM),
            ),
          ),
      ],
    );
  }
}

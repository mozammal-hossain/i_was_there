import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class BackgroundLocationStepsSection extends StatelessWidget {
  const BackgroundLocationStepsSection({
    super.key,
    required this.theme,
    required this.isDark,
  });

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: AppSize.iconM2),
            const SizedBox(width: AppSize.spacingM),
            Text(
              AppLocalizations.of(context)!.howToEnable,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSize.spacingL2),
        _StepRow(
          number: 1,
          text: AppLocalizations.of(context)!.tapOpenSettings,
          isDark: isDark,
          isLast: false,
        ),
        _StepRow(
          number: 2,
          text: AppLocalizations.of(context)!.goToPermissionsLocation,
          isDark: isDark,
          isLast: false,
        ),
        _StepRow(
          number: 3,
          text: AppLocalizations.of(context)!.selectAllowAllTheTime,
          isDark: isDark,
          isLast: true,
          highlight: true,
        ),
      ],
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.text,
    required this.isDark,
    required this.isLast,
    this.highlight = false,
  });

  final int number;
  final String text;
  final bool isDark;
  final bool isLast;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSize.spacingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _StepNumberCircle(number: number, highlight: highlight),
          const SizedBox(width: AppSize.spacingL),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSize.spacingS),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: AppSize.fontBodyLg,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepNumberCircle extends StatelessWidget {
  const _StepNumberCircle({required this.number, required this.highlight});

  final int number;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.iconNav,
      height: AppSize.iconNav,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: highlight
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primary.withValues(alpha: 0.1),
        border: Border.all(
          color: highlight
              ? AppColors.primary
              : AppColors.primary.withValues(alpha: 0.2),
          width: highlight ? AppSize.spacingXs : AppSize.borderWidth,
        ),
        boxShadow: highlight
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: AppSize.shadowBlurMd,
                ),
              ]
            : null,
      ),
      child: Center(
        child: Text(
          '$number',
          style: const TextStyle(
            fontSize: AppSize.fontBodySm,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

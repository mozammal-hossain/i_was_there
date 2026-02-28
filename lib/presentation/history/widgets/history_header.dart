import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key, this.onBack, required this.isDark});

  final VoidCallback? onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSize.spacingL,
        AppSize.spacingL,
        AppSize.spacingL,
        AppSize.spacingM,
      ),
      decoration: BoxDecoration(
        color: (isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight)
            .withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                foregroundColor: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
              ),
            )
          else
            const SizedBox(width: AppSize.avatarLg),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.presenceHistory,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.fontHeadlineSm,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                        AppLocalizations.of(context)!.syncComingSoon)),
              );
            },
            icon: const Icon(Icons.sync, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

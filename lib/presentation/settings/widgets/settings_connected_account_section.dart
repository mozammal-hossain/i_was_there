import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class SettingsConnectedAccountSection extends StatelessWidget {
  const SettingsConnectedAccountSection({
    super.key,
    required this.theme,
    required this.isDark,
    this.displayName,
    this.email,
    this.lastSyncedText,
  });

  final ThemeData theme;
  final bool isDark;
  /// Signed-in user display name. When null (with [email] null), "Not signed in" is shown.
  final String? displayName;
  final String? email;
  /// Pre-formatted relative time (e.g. "12m ago"). When null, "Never synced" is shown.
  final String? lastSyncedText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.connectedAccount,
          style: theme.textTheme.labelSmall?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w600,
            letterSpacing: AppSize.letterSpacingLg,
          ),
        ),
        const SizedBox(height: AppSize.spacingM3),
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.radiusXl),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSize.spacingL),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: AppSize.radiusCard,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      child: Icon(
                        Icons.person,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(width: AppSize.spacingL),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName ??
                                AppLocalizations.of(context)!.notSignedIn,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          if (email != null)
                            Text(
                              email!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isDark
                                    ? const Color(0xFF94A3B8)
                                    : const Color(0xFF64748B),
                                fontSize: AppSize.fontBodySm,
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                AppLocalizations.of(context)!.changeAccountComingSoon),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.change,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.spacingL,
                  vertical: AppSize.spacingM3,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(AppSize.radiusXl),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.history,
                          size: AppSize.iconS,
                          color: isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF64748B),
                        ),
                        const SizedBox(width: AppSize.spacingS2),
                        Text(
                          lastSyncedText != null
                              ? AppLocalizations.of(context)!
                                  .lastSyncedAt(lastSyncedText!)
                              : AppLocalizations.of(context)!.neverSynced,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontSize: AppSize.fontSmall,
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      AppLocalizations.of(context)!.connected,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        letterSpacing: AppSize.letterSpacingLg,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

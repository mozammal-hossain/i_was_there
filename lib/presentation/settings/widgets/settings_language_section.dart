import 'package:flutter/material.dart';
import 'package:i_was_there/core/di/injection.dart';
import 'package:i_was_there/core/locale/app_locale_service.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

/// Language row: label + current value. Tapping opens a picker (English / Bangla).
class SettingsLanguageSection extends StatelessWidget {
  const SettingsLanguageSection({
    super.key,
    required this.theme,
    required this.isDark,
  });

  final ThemeData theme;
  final bool isDark;

  /// Returns the localized display name for [locale] using [l10n].
  static String _displayNameForLocale(Locale locale, AppLocalizations l10n) {
    switch (locale.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'bn':
        return l10n.languageBangla;
      default:
        return locale.languageCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final currentLabel = _displayNameForLocale(locale, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(AppSize.spacingL2),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(AppSize.radiusXl),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
          ),
          child: InkWell(
            onTap: () => _showLanguagePicker(context),
            borderRadius: BorderRadius.circular(AppSize.radiusXl),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSize.spacingS),
              child: Row(
                children: [
                  Icon(
                    Icons.language,
                    size: AppSize.iconS2,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSize.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.language,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: AppSize.spacingS),
                        Text(
                          currentLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            fontSize: AppSize.fontBody2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: AppSize.iconM,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = getIt<AppLocaleService>();

    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final locale in AppLocalizations.supportedLocales)
              ListTile(
                title: Text(_displayNameForLocale(locale, l10n)),
                onTap: () {
                  localeService.setLocale(locale);
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

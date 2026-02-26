import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_connected_account_section.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_footer.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_header.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_sync_details_section.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_sync_now_button.dart';
import 'package:i_was_there/presentation/settings/widgets/settings_sync_section.dart';

/// Calendar Sync settings. Sync toggle, connected account, Sync Now.
/// All state comes from [SettingsBloc]; this page only renders and dispatches events.
class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    this.onBack,
    required this.syncEnabled,
    required this.loading,
    required this.onSyncEnabledChanged,
  });

  final VoidCallback? onBack;
  final bool syncEnabled;
  final bool loading;
  final void Function(bool) onSyncEnabledChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SettingsHeader(onBack: onBack, isDark: isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSize.spacingL,
                  vertical: AppSize.spacingXl3,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SettingsSyncSection(
                      syncEnabled: syncEnabled,
                      loading: loading,
                      theme: theme,
                      isDark: isDark,
                      onChanged: onSyncEnabledChanged,
                    ),
                    const SizedBox(height: AppSize.spacingXl3),
                    SettingsConnectedAccountSection(
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSize.spacingXl3),
                    SettingsSyncDetailsSection(
                      theme: theme,
                      isDark: isDark,
                    ),
                    const SizedBox(height: AppSize.spacingXl),
                    const SettingsSyncNowButton(),
                    const SizedBox(height: AppSize.spacingXl5),
                    SettingsFooter(theme: theme, isDark: isDark),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

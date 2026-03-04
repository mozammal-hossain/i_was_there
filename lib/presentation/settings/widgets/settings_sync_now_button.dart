import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class SettingsSyncNowButton extends StatelessWidget {
  const SettingsSyncNowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      buildWhen: (previous, current) =>
          previous.isSyncing != current.isSyncing ||
          previous.googleEmail != current.googleEmail,
      builder: (context, state) {
        final isSignedIn = state.googleEmail != null;
        final isLoading = state.isSyncing;

        return SizedBox(
          width: double.infinity,
          height: AppSize.buttonHeight,
          child: FilledButton.icon(
            onPressed: !isSignedIn || isLoading
                ? null
                : () {
                    context.read<SettingsBloc>().add(
                      SettingsSyncNowRequested(),
                    );
                  },
            icon: isLoading
                ? const SizedBox(
                    width: AppSize.iconM,
                    height: AppSize.iconM,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sync, size: AppSize.iconM),
            label: Text(
              AppLocalizations.of(context)!.syncNow,
              style: TextStyle(
                fontSize: AppSize.fontBodyLg,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade400,
              disabledForegroundColor: Colors.grey.shade600,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.radiusXl),
              ),
            ),
          ),
        );
      },
    );
  }
}

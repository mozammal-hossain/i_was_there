import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import '../domain/settings/use_cases/get_last_sync_time_use_case.dart';
import '../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'settings/bloc/settings_bloc.dart';
import 'settings/bloc/settings_event.dart';
import 'settings/bloc/settings_state.dart';
import 'settings/settings_page.dart';

/// Settings feature: Calendar Sync and app settings.
class SettingsFeature extends StatelessWidget {
  const SettingsFeature({super.key});

  SettingsBloc _createSettingsBloc() {
    return SettingsBloc(
      getCalendarSyncEnabled: getIt<GetCalendarSyncEnabledUseCase>(),
      setCalendarSyncEnabled: getIt<SetCalendarSyncEnabledUseCase>(),
      getLastSyncTime: getIt<GetLastSyncTimeUseCase>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createSettingsBloc()..add(SettingsLoadRequested()),
      child: BlocConsumer<SettingsBloc, SettingsState>(
        listenWhen: (prev, curr) => curr.errorMessage != prev.errorMessage,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SettingsPage(
            syncEnabled: state.syncEnabled,
            loading: state.loading,
            lastSyncTime: state.lastSyncTime,
            onSyncEnabledChanged: (value) => context
                .read<SettingsBloc>()
                .add(SettingsSyncEnabledChanged(value)),
          );
        },
      ),
    );
  }
}

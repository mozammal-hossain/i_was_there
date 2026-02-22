import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../domain/settings/use_cases/get_calendar_sync_enabled.dart';
import '../../domain/settings/use_cases/set_calendar_sync_enabled.dart';
import 'bloc/settings_bloc.dart';
import 'bloc/settings_event.dart';
import 'bloc/settings_state.dart';
import 'widgets/settings_screen.dart';

/// Settings feature: Calendar Sync and app settings.
class SettingsFeature extends StatelessWidget {
  const SettingsFeature({super.key});

  SettingsBloc _createSettingsBloc() {
    return SettingsBloc(
      getCalendarSyncEnabled: getIt<GetCalendarSyncEnabled>(),
      setCalendarSyncEnabled: getIt<SetCalendarSyncEnabled>(),
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
          return SettingsScreen(
            syncEnabled: state.syncEnabled,
            loading: state.loading,
            onSyncEnabledChanged: (value) => context
                .read<SettingsBloc>()
                .add(SettingsSyncEnabledChanged(value)),
          );
        },
      ),
    );
  }
}

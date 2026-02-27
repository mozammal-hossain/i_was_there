import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import '../../../../domain/settings/use_cases/get_last_sync_time_use_case.dart';
import '../../../../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetCalendarSyncEnabledUseCase getCalendarSyncEnabled,
    required SetCalendarSyncEnabledUseCase setCalendarSyncEnabled,
    required GetLastSyncTimeUseCase getLastSyncTime,
  })  : _getCalendarSyncEnabled = getCalendarSyncEnabled,
        _setCalendarSyncEnabled = setCalendarSyncEnabled,
        _getLastSyncTime = getLastSyncTime,
        super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsSyncEnabledChanged>(_onSyncEnabledChanged);
  }

  final GetCalendarSyncEnabledUseCase _getCalendarSyncEnabled;
  final SetCalendarSyncEnabledUseCase _setCalendarSyncEnabled;
  final GetLastSyncTimeUseCase _getLastSyncTime;

  Future<void> _onLoad(
      SettingsLoadRequested event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final enabled = await _getCalendarSyncEnabled.call();
      final lastSyncTime = await _getLastSyncTime.call();
      emit(state.copyWith(
        syncEnabled: enabled,
        lastSyncTime: lastSyncTime,
        loading: false,
      ));
    } catch (e, _) {
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onSyncEnabledChanged(
      SettingsSyncEnabledChanged event, Emitter<SettingsState> emit) async {
    emit(state.copyWith(syncEnabled: event.enabled));
    try {
      await _setCalendarSyncEnabled.call(event.enabled);
      emit(state.copyWith(errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(
        syncEnabled: !event.enabled,
        errorMessage: e.toString(),
      ));
    }
  }
}

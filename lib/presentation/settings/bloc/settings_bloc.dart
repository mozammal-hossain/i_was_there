import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import '../../../../domain/settings/use_cases/get_last_sync_time_use_case.dart';
import '../../../../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import '../../../../domain/settings/use_cases/set_last_sync_time_use_case.dart';
import '../../../../domain/sync/use_cases/get_google_account_use_case.dart';
import '../../../../domain/sync/use_cases/sign_in_with_google_use_case.dart';
import '../../../../domain/sync/use_cases/sign_out_google_use_case.dart';
import '../../../../domain/sync/use_cases/sync_pending_to_google_use_case.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required GetCalendarSyncEnabledUseCase getCalendarSyncEnabled,
    required SetCalendarSyncEnabledUseCase setCalendarSyncEnabled,
    required GetLastSyncTimeUseCase getLastSyncTime,
    required SetLastSyncTimeUseCase setLastSyncTime,
    required SignInWithGoogleUseCase signInWithGoogle,
    required SignOutGoogleUseCase signOutGoogle,
    required GetGoogleAccountUseCase getGoogleAccount,
    required SyncPendingToGoogleUseCase syncPendingToGoogle,
  }) : _getCalendarSyncEnabled = getCalendarSyncEnabled,
       _setCalendarSyncEnabled = setCalendarSyncEnabled,
       _getLastSyncTime = getLastSyncTime,
       _setLastSyncTime = setLastSyncTime,
       _signInWithGoogle = signInWithGoogle,
       _signOutGoogle = signOutGoogle,
       _getGoogleAccount = getGoogleAccount,
       _syncPendingToGoogle = syncPendingToGoogle,
       super(const SettingsState()) {
    on<SettingsLoadRequested>(_onLoad);
    on<SettingsSyncEnabledChanged>(_onSyncEnabledChanged);
    on<SettingsGoogleSignInRequested>(_onSignIn);
    on<SettingsGoogleSignOutRequested>(_onSignOut);
    on<SettingsSyncNowRequested>(_onSyncNow);
    on<SettingsAccountLoadRequested>(_onAccountLoad);
  }

  final GetCalendarSyncEnabledUseCase _getCalendarSyncEnabled;
  final SetCalendarSyncEnabledUseCase _setCalendarSyncEnabled;
  final GetLastSyncTimeUseCase _getLastSyncTime;
  final SetLastSyncTimeUseCase _setLastSyncTime;
  final SignInWithGoogleUseCase _signInWithGoogle;
  final SignOutGoogleUseCase _signOutGoogle;
  final GetGoogleAccountUseCase _getGoogleAccount;
  final SyncPendingToGoogleUseCase _syncPendingToGoogle;

  Future<void> _onLoad(
    SettingsLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(loading: true, errorMessage: null));
    try {
      final enabled = await _getCalendarSyncEnabled.call();
      final lastSyncTime = await _getLastSyncTime.call();
      emit(
        state.copyWith(
          syncEnabled: enabled,
          lastSyncTime: lastSyncTime,
          loading: false,
        ),
      );
      // Load account info after loading settings
      add(SettingsAccountLoadRequested());
    } catch (e, _) {
      emit(state.copyWith(loading: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSyncEnabledChanged(
    SettingsSyncEnabledChanged event,
    Emitter<SettingsState> emit,
  ) async {
    // if the user is turning sync on and we have no signed‑in account,
    // attempt to sign them in first.  if the sign‑in fails we revert the toggle
    if (event.enabled && state.googleEmail == null) {
      emit(state.copyWith(signInError: null));
      try {
        final account = await _signInWithGoogle.call();
        if (account == null) {
          // user cancelled or auth service returned null
          emit(
            state.copyWith(syncEnabled: false, signInError: 'Sign in required'),
          );
          return;
        }
        emit(
          state.copyWith(
            googleDisplayName: account.displayName,
            googleEmail: account.email,
          ),
        );
        // new account means we can turn sync on
        await _setCalendarSyncEnabled.call(true);
        emit(state.copyWith(syncEnabled: true, errorMessage: null));
      } catch (e, _) {
        emit(state.copyWith(syncEnabled: false, signInError: e.toString()));
      }
      return;
    }

    // default behaviour for toggling
    emit(state.copyWith(syncEnabled: event.enabled));
    try {
      await _setCalendarSyncEnabled.call(event.enabled);
      emit(state.copyWith(errorMessage: null));
    } catch (e, _) {
      emit(
        state.copyWith(syncEnabled: !event.enabled, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onSignIn(
    SettingsGoogleSignInRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(signInError: null));
    try {
      final account = await _signInWithGoogle.call();
      if (account == null) {
        // user cancelled or sign-in failed silently
        emit(state.copyWith(signInError: 'Sign in cancelled or failed'));
        return;
      }

      emit(
        state.copyWith(
          googleDisplayName: account.displayName,
          googleEmail: account.email,
        ),
      );
      // Enable sync after successful sign-in
      await _setCalendarSyncEnabled.call(true);
      emit(state.copyWith(syncEnabled: true));
    } catch (e, _) {
      emit(state.copyWith(signInError: e.toString()));
    }
  }

  Future<void> _onSignOut(
    SettingsGoogleSignOutRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _signOutGoogle.call();
      // disable calendar sync when there's no account and clear account info
      await _setCalendarSyncEnabled.call(false);
      emit(
        state.copyWith(
          googleDisplayName: null,
          googleEmail: null,
          syncEnabled: false,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(signInError: e.toString()));
    }
  }

  Future<void> _onSyncNow(
    SettingsSyncNowRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(state.copyWith(isSyncing: true, errorMessage: null));
    try {
      await _syncPendingToGoogle.call();
      final now = DateTime.now();
      await _setLastSyncTime.call(now);
      emit(state.copyWith(isSyncing: false, lastSyncTime: now));
    } catch (e, _) {
      emit(state.copyWith(isSyncing: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onAccountLoad(
    SettingsAccountLoadRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final account = await _getGoogleAccount.call();
      if (account != null) {
        emit(
          state.copyWith(
            googleDisplayName: account.displayName,
            googleEmail: account.email,
          ),
        );
      }
    } catch (e, _) {
      // Silent fail for account load, don't show error
    }
  }
}

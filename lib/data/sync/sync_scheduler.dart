import 'package:injectable/injectable.dart';

import '../../domain/settings/repositories/settings_repository.dart';
import '../../domain/sync/google_auth_service.dart';
import '../../domain/sync/use_cases/sync_pending_to_google_use_case.dart';

@lazySingleton
class SyncScheduler {
  SyncScheduler(
    this._settingsRepository,
    this._googleAuthService,
    this._syncPendingToGoogle,
  );

  final SettingsRepository _settingsRepository;
  final GoogleAuthService _googleAuthService;
  final SyncPendingToGoogleUseCase _syncPendingToGoogle;

  /// Syncs if enabled and user is signed in.
  Future<void> syncIfNeeded() async {
    final enabled = await _settingsRepository.getCalendarSyncEnabled();
    if (!enabled) return;

    final account = await _googleAuthService.getCurrentAccount();
    if (account == null) return;

    await _syncPendingToGoogle.call();
  }
}

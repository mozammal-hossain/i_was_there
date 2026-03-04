import 'package:injectable/injectable.dart';

import '../../core/logging.dart';
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
    appLogger.d('SyncScheduler: checking if sync is needed');
    final enabled = await _settingsRepository.getCalendarSyncEnabled();
    if (!enabled) {
      appLogger.d('Calendar sync disabled');
      return;
    }

    final account = await _googleAuthService.getCurrentAccount();
    if (account == null) {
      appLogger.d('No signed-in Google account');
      return;
    }

    appLogger.i('Starting pending sync for account ${account.email}');
    try {
      await _syncPendingToGoogle.call();
      appLogger.i('Pending sync completed');
    } catch (e, st) {
      appLogger.w(
        'Manual/Scheduled sync failed silently',
        error: e,
        stackTrace: st,
      );
    }
  }
}

import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import '../../data/places/repositories/place_repository_impl.dart';
import '../../data/presence/repositories/presence_repository_impl.dart';
import '../../data/settings/repositories/settings_repository_impl.dart';
import '../../data/sync/google_auth_service_impl.dart';
import '../../data/sync/repositories/sync_repository_impl.dart';
import '../../data/sync/sync_client.dart';
import 'package:dio/dio.dart';
import '../di/network_module.dart';
import '../logging.dart';
import '../../domain/presence/entities/presence.dart';
import '../../domain/sync/repositories/sync_repository.dart';
import '../../domain/sync/use_cases/sync_pending_to_google_use_case.dart';
import '../util/haversine.dart';
import 'location_callback.dart';

const String _taskName = 'i_was_there_location_check';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    return runBackgroundLocationCheck();
  });
}

/// Runs in background isolate: get location, update presence for places within 20 m (PRD R5, R6).
Future<bool> runBackgroundLocationCheck() async {
  try {
    final db = AppDatabase();
    final placeRepo = PlaceRepositoryImpl(db);
    final presenceRepo = PresenceRepositoryImpl(db);
    final places = await placeRepo.getPlaces();
    if (places.isEmpty) return true;

    appLogger.d('Background location check starting');
    final location = await getCurrentPositionInBackground();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final place in places) {
      final dist = haversineMeters(
        location.latitude,
        location.longitude,
        place.latitude,
        place.longitude,
      );
      if (dist <= 20) {
        await presenceRepo.setPresence(
          placeId: place.id,
          date: today,
          isPresent: true,
          source: PresenceSource.auto,
          firstDetectedAt: now,
        );
      }
    }

    // Sync pending presences to Google Calendar if enabled
    appLogger.d('Background task: invoking _syncIfNeeded');
    await _syncIfNeeded(db);

    return true;
  } catch (_) {
    return false;
  }
}

/// Syncs pending presences in background isolate.
Future<void> _syncIfNeeded(AppDatabase db) async {
  try {
    final settingsRepo = SettingsRepositoryImpl(db);
    final enabled = await settingsRepo.getCalendarSyncEnabled();
    if (!enabled) return;

    final authService = GoogleAuthServiceImpl();
    final account = await authService.getCurrentAccount();
    if (account == null) return;

    final syncRepo = SyncRepositoryImpl(db) as SyncRepository;
    // Construct a Dio instance identical to the one provided via DI in
    // the main isolate.  We can't use getIt here because the background
    // isolate is started separately, so we replicate the configuration.
    final Dio dio = NetworkModuleImpl().provideDio(authService);
    final syncClient = SyncClient(dio);
    final syncUseCase = SyncPendingToGoogleUseCase(syncRepo, syncClient);
    await syncUseCase.call();
  } catch (e, st) {
    appLogger.w('Background sync failed', error: e, stackTrace: st);
    // Silently fail; sync errors shouldn't break location check
  }
}

/// Register periodic background work (15 min minimum per Android).
Future<void> registerBackgroundTask() {
  return Workmanager().initialize(callbackDispatcher).then((_) {
    Workmanager().registerPeriodicTask(
      'periodic_location_check',
      _taskName,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 1),
    );
  });
}

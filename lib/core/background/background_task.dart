import 'package:workmanager/workmanager.dart';

import '../../data/database/app_database.dart';
import '../../data/places/repositories/place_repository_impl.dart';
import '../../data/presence/repositories/presence_repository_impl.dart';
import '../../domain/presence/entities/presence.dart';
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
    return true;
  } catch (_) {
    return false;
  }
}

/// Register periodic background work (15 min minimum per Android).
Future<void> registerBackgroundTask() {
  return Workmanager()
      .initialize(callbackDispatcher)
      .then((_) {
        Workmanager().registerPeriodicTask(
          'periodic_location_check',
          _taskName,
          frequency: const Duration(minutes: 15),
          initialDelay: const Duration(minutes: 1),
        );
      });
}

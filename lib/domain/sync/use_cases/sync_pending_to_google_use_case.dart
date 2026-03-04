import 'package:injectable/injectable.dart';

import '../../../core/logging.dart';
import '../calendar_sync_service.dart';
import '../repositories/sync_repository.dart';

@injectable
class SyncPendingToGoogleUseCase {
  SyncPendingToGoogleUseCase(this._syncRepository, this._calendarSyncService);

  final SyncRepository _syncRepository;
  final CalendarSyncService _calendarSyncService;

  Future<void> call() async {
    final pending = await _syncRepository.getPendingSyncs();
    appLogger.i('SyncPendingToGoogleUseCase: ${pending.length} items pending');
    for (final item in pending) {
      appLogger.d('Syncing item ${item.placeId} at ${item.date}');
      final eventId = await _calendarSyncService.createEvent(
        placeName: item.placeName,
        date: item.date,
        firstDetectedAt: item.firstDetectedAt,
      );
      appLogger.d('Event created with id $eventId');
      await _syncRepository.markSynced(item.placeId, item.date, eventId);
    }
    appLogger.i('SyncPendingToGoogleUseCase: completed');
  }
}

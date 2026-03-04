import 'package:injectable/injectable.dart';

import '../../../core/logging.dart';
import '../../../core/sync/sync_lock.dart';
import '../calendar_sync_service.dart';
import '../repositories/sync_repository.dart';

@injectable
class SyncPendingToGoogleUseCase {
  SyncPendingToGoogleUseCase(
    this._syncRepository,
    this._calendarSyncService,
    this._syncLock,
  );

  final SyncRepository _syncRepository;
  final CalendarSyncService _calendarSyncService;
  final SyncLock _syncLock;

  Future<void> call() async {
    await _syncLock.lock.synchronized(() async {
      final pending = await _syncRepository.getPendingSyncs();
      appLogger.i(
        'SyncPendingToGoogleUseCase: ${pending.length} items pending',
      );
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
    });
  }
}

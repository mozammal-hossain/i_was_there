import 'package:injectable/injectable.dart';

import '../calendar_sync_service.dart';
import '../repositories/sync_repository.dart';

@injectable
class SyncPendingToGoogleUseCase {
  SyncPendingToGoogleUseCase(this._syncRepository, this._calendarSyncService);

  final SyncRepository _syncRepository;
  final CalendarSyncService _calendarSyncService;

  Future<void> call() async {
    final pending = await _syncRepository.getPendingSyncs();
    for (final item in pending) {
      final eventId = await _calendarSyncService.createEvent(
        placeName: item.placeName,
        date: item.date,
        firstDetectedAt: item.firstDetectedAt,
      );
      await _syncRepository.markSynced(item.placeId, item.date, eventId);
    }
  }
}

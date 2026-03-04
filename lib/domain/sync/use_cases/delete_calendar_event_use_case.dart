import 'package:injectable/injectable.dart';

import '../calendar_sync_service.dart';
import '../repositories/sync_repository.dart';

@injectable
class DeleteCalendarEventUseCase {
  DeleteCalendarEventUseCase(this._syncRepository, this._calendarSyncService);

  final SyncRepository _syncRepository;
  final CalendarSyncService _calendarSyncService;

  Future<void> call(String placeId, DateTime date) async {
    final eventId = await _syncRepository.getEventId(placeId, date);
    if (eventId != null) {
      await _calendarSyncService.deleteEvent(eventId);
      await _syncRepository.removeSyncRecord(placeId, date);
    }
  }
}

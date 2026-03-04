import '../entities/pending_sync_item.dart';

abstract class SyncRepository {
  /// Returns presences that are marked present but not yet synced to Google Calendar.
  Future<List<PendingSyncItem>> getPendingSyncs();

  /// Records that a presence was synced, storing the Google Calendar event ID.
  Future<void> markSynced(String placeId, DateTime date, String eventId);

  /// Returns the Google Calendar event ID for a synced presence, or null.
  Future<String?> getEventId(String placeId, DateTime date);

  /// Removes the sync record (after deleting the calendar event).
  Future<void> removeSyncRecord(String placeId, DateTime date);
}

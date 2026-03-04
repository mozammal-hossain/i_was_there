abstract class CalendarSyncService {
  /// Creates a calendar event. Returns the event ID.
  Future<String> createEvent({
    required String placeName,
    required DateTime date,
    DateTime? firstDetectedAt,
  });

  /// Deletes a calendar event by its ID.
  Future<void> deleteEvent(String eventId);
}

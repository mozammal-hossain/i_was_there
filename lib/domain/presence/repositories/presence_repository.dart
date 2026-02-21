import '../entities/presence.dart';

/// Domain interface for presence (per place, per day). Implemented in data layer.
abstract class PresenceRepository {
  /// Presence for a place on a calendar day (date at midnight).
  Future<Presence?> getPresence(String placeId, DateTime date);

  /// All presence rows for a place in the given month (for calendar UI).
  Future<List<Presence>> getPresenceForMonth(String placeId, int year, int month);

  /// Aggregated: for each day in [start, end], true if present at any place.
  Future<Map<DateTime, bool>> getAggregatedPresenceInRange(DateTime start, DateTime end);

  /// All presence records for a single calendar day (for day-detail UI).
  Future<List<Presence>> getPresencesForDay(DateTime date);

  /// Set presence for (placeId, date). [source] = manual or auto.
  Future<void> setPresence({
    required String placeId,
    required DateTime date,
    required bool isPresent,
    required PresenceSource source,
    DateTime? firstDetectedAt,
  });
}

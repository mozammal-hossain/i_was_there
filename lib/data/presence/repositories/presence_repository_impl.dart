import 'package:drift/drift.dart';

import '../../../../domain/presence/entities/presence.dart' as domain;
import '../../../../domain/presence/repositories/presence_repository.dart';
import '../../database/app_database.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  PresenceRepositoryImpl(this._db);

  final AppDatabase _db;

  static DateTime _calendarDay(DateTime d) => DateTime(d.year, d.month, d.day);

  @override
  Future<domain.Presence?> getPresence(String placeId, DateTime date) async {
    final day = _calendarDay(date);
    final row = await (_db.select(_db.presences)
          ..where((t) => t.placeId.equals(placeId) & t.date.equals(day)))
        .getSingleOrNull();
    if (row == null) return null;
    return domain.Presence(
      placeId: row.placeId,
      date: row.date,
      isPresent: row.isPresent,
      source: domain.PresenceSource.values[row.source],
      firstDetectedAt: row.firstDetectedAt,
    );
  }

  @override
  Future<List<domain.Presence>> getPresenceForMonth(String placeId, int year, int month) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0); // last day of month
    final rows = await (_db.select(_db.presences)
          ..where((t) =>
              t.placeId.equals(placeId) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(end)))
        .get();
    return rows
        .map((r) => domain.Presence(
              placeId: r.placeId,
              date: r.date,
              isPresent: r.isPresent,
              source: domain.PresenceSource.values[r.source],
              firstDetectedAt: r.firstDetectedAt,
            ))
        .toList();
  }

  @override
  Future<List<domain.Presence>> getPresencesForDay(DateTime date) async {
    final day = _calendarDay(date);
    final rows = await (_db.select(_db.presences)
          ..where((t) => t.date.equals(day) & t.isPresent.equals(true)))
        .get();
    return rows
        .map((r) => domain.Presence(
              placeId: r.placeId,
              date: r.date,
              isPresent: r.isPresent,
              source: domain.PresenceSource.values[r.source],
              firstDetectedAt: r.firstDetectedAt,
            ))
        .toList();
  }

  @override
  Future<Map<DateTime, bool>> getAggregatedPresenceInRange(DateTime start, DateTime end) async {
    final startDay = _calendarDay(start);
    final endDay = _calendarDay(end);
    // Any place present on that day => day is present (aggregated view).
    final rows = await (_db.select(_db.presences)
          ..where((t) =>
              t.isPresent.equals(true) &
              t.date.isBiggerOrEqualValue(startDay) &
              t.date.isSmallerOrEqualValue(endDay)))
        .get();
    final map = <DateTime, bool>{};
    for (var d = startDay; !d.isAfter(endDay); d = d.add(const Duration(days: 1))) {
      map[d] = false;
    }
    for (final r in rows) {
      map[r.date] = true;
    }
    return map;
  }

  @override
  Future<void> setPresence({
    required String placeId,
    required DateTime date,
    required bool isPresent,
    required domain.PresenceSource source,
    DateTime? firstDetectedAt,
  }) async {
    final day = _calendarDay(date);
    await _db.into(_db.presences).insert(
          PresencesCompanion.insert(
            placeId: placeId,
            date: day,
            isPresent: isPresent,
            source: source.index,
            firstDetectedAt: Value(firstDetectedAt),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}

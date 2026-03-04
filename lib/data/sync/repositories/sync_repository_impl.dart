import 'package:drift/drift.dart';

import '../../../data/database/app_database.dart';
import '../../../domain/sync/entities/pending_sync_item.dart';
import '../../../domain/sync/repositories/sync_repository.dart';

class SyncRepositoryImpl implements SyncRepository {
  SyncRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<PendingSyncItem>> getPendingSyncs() async {
    final now = DateTime.now();
    final minDate = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 90));

    final query =
        _db.select(_db.presences).join([
            innerJoin(
              _db.places,
              _db.places.placeId.equalsExp(_db.presences.placeId),
            ),
            leftOuterJoin(
              _db.syncRecords,
              _db.syncRecords.placeId.equalsExp(_db.presences.placeId) &
                  _db.syncRecords.date.equalsExp(_db.presences.date),
            ),
          ])
          ..where(_db.presences.isPresent.equals(true))
          ..where(_db.presences.date.isBiggerOrEqualValue(minDate))
          ..where(_db.syncRecords.placeId.isNull());

    final results = await query.get();

    return results.map((row) {
      final presence = row.readTable(_db.presences);
      final place = row.readTable(_db.places);

      return PendingSyncItem(
        placeId: presence.placeId,
        placeName: place.name,
        date: presence.date,
        firstDetectedAt: presence.firstDetectedAt,
      );
    }).toList();
  }

  @override
  Future<void> markSynced(String placeId, DateTime date, String eventId) async {
    await _db
        .into(_db.syncRecords)
        .insert(
          SyncRecordsCompanion(
            placeId: Value(placeId),
            date: Value(date),
            eventId: Value(eventId),
            syncedAt: Value(DateTime.now()),
          ),
        );
  }

  @override
  Future<String?> getEventId(String placeId, DateTime date) async {
    final record =
        await (_db.select(_db.syncRecords)
              ..where((s) => s.placeId.equals(placeId) & s.date.equals(date)))
            .getSingleOrNull();

    return record?.eventId;
  }

  @override
  Future<void> removeSyncRecord(String placeId, DateTime date) async {
    await (_db.delete(
      _db.syncRecords,
    )..where((s) => s.placeId.equals(placeId) & s.date.equals(date))).go();
  }

  @override
  Future<Map<DateTime, Set<String>>> getSyncedDaysForMonth(
    int year,
    int month,
  ) async {
    final start = DateTime(year, month, 1);
    final end = DateTime(year, month + 1, 0);

    final query = _db.select(_db.syncRecords)
      ..where((s) => s.date.isBetweenValues(start, end));

    final results = await query.get();
    final map = <DateTime, Set<String>>{};

    for (final row in results) {
      final date = DateTime(row.date.year, row.date.month, row.date.day);
      map.putIfAbsent(date, () => {}).add(row.placeId);
    }

    return map;
  }
}

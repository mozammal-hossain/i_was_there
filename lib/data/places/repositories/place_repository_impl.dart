import 'package:drift/drift.dart';

import '../../../../domain/places/entities/place.dart' as domain;
import '../../../../domain/places/repositories/place_repository.dart';
import '../../database/app_database.dart';
import '../mappers/place_mapper.dart';

class PlaceRepositoryImpl implements PlaceRepository {
  PlaceRepositoryImpl(this._db);

  final AppDatabase _db;

  /// Start of current week (Monday 00:00 local).
  static DateTime _startOfWeek(DateTime now) {
    final d = DateTime(now.year, now.month, now.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  /// End of current week (Sunday 00:00 local), inclusive for calendar day query.
  static DateTime _endOfWeek(DateTime now) {
    final start = _startOfWeek(now);
    return start.add(const Duration(days: 6));
  }

  @override
  Future<List<domain.Place>> getPlaces() async {
    final rows = await _db.select(_db.places).get();
    final now = DateTime.now();
    final start = _startOfWeek(now);
    final places = <domain.Place>[];

    for (final row in rows) {
      final presences = await (_db.select(_db.presences)
            ..where((t) =>
                t.placeId.equals(row.placeId) &
                t.date.isBiggerOrEqualValue(start) &
                t.date.isSmallerOrEqualValue(_endOfWeek(now))))
          .get();

      // Build [Mon..Sun] presence (index 0 = Monday).
      final weeklyPresence = List<bool>.filled(7, false);
      for (final p in presences) {
        if (!p.isPresent) continue;
        final dayOffset = p.date.difference(start).inDays;
        if (dayOffset >= 0 && dayOffset < 7) {
          weeklyPresence[dayOffset] = true;
        }
      }
      places.add(PlaceMapper.fromDriftRow(row, weeklyPresence));
    }
    return places;
  }

  @override
  Future<domain.Place?> getPlace(String id) async {
    final row = await (_db.select(_db.places)..where((t) => t.placeId.equals(id))).getSingleOrNull();
    if (row == null) return null;
    final now = DateTime.now();
    final start = _startOfWeek(now);
    final presences = await (_db.select(_db.presences)
          ..where((t) =>
              t.placeId.equals(id) &
              t.date.isBiggerOrEqualValue(start) &
              t.date.isSmallerOrEqualValue(_endOfWeek(now))))
        .get();
    final weeklyPresence = List<bool>.filled(7, false);
    for (final p in presences) {
      if (!p.isPresent) continue;
      final dayOffset = p.date.difference(start).inDays;
      if (dayOffset >= 0 && dayOffset < 7) weeklyPresence[dayOffset] = true;
    }
    return PlaceMapper.fromDriftRow(row, weeklyPresence);
  }

  @override
  Future<void> addPlace(domain.Place place) async {
    await _db.into(_db.places).insert(PlacesCompanion.insert(
          placeId: place.id,
          name: place.name,
          address: place.address,
          latitude: place.latitude,
          longitude: place.longitude,
          syncStatusIndex: Value(place.syncStatus.index),
        ));
  }

  @override
  Future<void> updatePlace(domain.Place place) async {
    await _db.update(_db.places).replace(PlacesCompanion(
          placeId: Value(place.id),
          name: Value(place.name),
          address: Value(place.address),
          latitude: Value(place.latitude),
          longitude: Value(place.longitude),
          syncStatusIndex: Value(place.syncStatus.index),
        ));
  }

  @override
  Future<void> removePlace(String id) async {
    await (_db.delete(_db.places)..where((t) => t.placeId.equals(id))).go();
  }
}

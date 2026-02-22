import '../../../../domain/places/entities/place.dart';
import '../../database/app_database.dart' as db;
import '../models/place_model.dart';

class PlaceMapper {
  /// Map Drift Places row + weekly presence to domain Place.
  static Place fromDriftRow(db.Place row, List<bool> weeklyPresence) {
    return Place(
      id: row.placeId,
      name: row.name,
      address: row.address,
      latitude: row.latitude,
      longitude: row.longitude,
      syncStatus:
          PlaceSyncStatus.values[row.syncStatusIndex.clamp(
            0,
            PlaceSyncStatus.values.length - 1,
          )],
      weeklyPresence: weeklyPresence,
    );
  }

  static Place toEntity(PlaceModel model) {
    return Place(
      id: model.id,
      name: model.name,
      address: model.address,
      latitude: model.latitude,
      longitude: model.longitude,
      syncStatus:
          PlaceSyncStatus.values[model.syncStatusIndex.clamp(
            0,
            PlaceSyncStatus.values.length - 1,
          )],
      weeklyPresence: List<bool>.from(model.weeklyPresence),
    );
  }

  static PlaceModel toModel(Place entity) {
    return PlaceModel(
      id: entity.id,
      name: entity.name,
      address: entity.address,
      latitude: entity.latitude,
      longitude: entity.longitude,
      syncStatusIndex: entity.syncStatus.index,
      weeklyPresence: List<bool>.from(entity.weeklyPresence),
    );
  }
}

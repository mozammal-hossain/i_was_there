import '../entities/place.dart';

/// Domain interface for place persistence. Implemented in data layer.
abstract class PlaceRepository {
  Future<List<Place>> getPlaces();
  Future<Place?> getPlace(String id);
  Future<void> addPlace(Place place);
  Future<void> updatePlace(Place place);
  Future<void> removePlace(String id);
}

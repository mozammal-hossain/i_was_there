import '../models/place_model.dart';

/// In-memory store for places. Replace with Drift/SQLite when persisting.
class PlacesMemoryDataSource {
  final List<PlaceModel> _places = [];

  List<PlaceModel> get places => List.unmodifiable(_places);

  void add(PlaceModel model) {
    _places.add(model);
  }

  void update(PlaceModel model) {
    final i = _places.indexWhere((p) => p.id == model.id);
    if (i >= 0) _places[i] = model;
  }

  void remove(String id) {
    _places.removeWhere((p) => p.id == id);
  }

  PlaceModel? get(String id) {
    try {
      return _places.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

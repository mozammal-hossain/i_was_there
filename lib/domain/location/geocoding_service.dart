/// Domain interface for reverse geocoding (coordinates → address).
/// Implemented in data layer.
abstract class GeocodingService {
  /// Returns a human-readable address for the given coordinates, or null if unavailable.
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);
}

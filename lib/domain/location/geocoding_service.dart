import 'current_location_result.dart';

/// Domain interface for geocoding (reverse: coordinates → address; forward: address → coordinates).
/// Implemented in data layer.
abstract class GeocodingService {
  /// Returns a human-readable address for the given coordinates, or null if unavailable.
  Future<String?> getAddressFromCoordinates(double latitude, double longitude);

  /// Forward geocoding: returns coordinates and a display address for the given query, or null if not found.
  Future<CurrentLocationResult?> getLocationFromAddress(String address);
}

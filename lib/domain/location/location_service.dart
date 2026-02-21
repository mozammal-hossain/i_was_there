/// Result of a location request (domain-level, no Flutter/plugin types).
class LocationResult {
  const LocationResult({required this.latitude, required this.longitude});
  final double latitude;
  final double longitude;
}

/// Domain interface for getting current device location. Implemented in data layer.
abstract class LocationService {
  /// Returns current position or throws if permission/location unavailable.
  Future<LocationResult> getCurrentPosition();
}

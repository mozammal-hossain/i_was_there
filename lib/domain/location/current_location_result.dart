/// Result of getting current location with optional reverse-geocoded address.
class CurrentLocationResult {
  const CurrentLocationResult({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  final double latitude;
  final double longitude;
  final String? address;
}

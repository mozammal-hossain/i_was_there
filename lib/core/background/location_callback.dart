import 'package:geolocator/geolocator.dart';

import '../../domain/location/location_service.dart';

/// Gets current position in background (used from WorkManager isolate).
/// Uses Geolocator directly so we don't depend on injected LocationService.
Future<LocationResult> getCurrentPositionInBackground() async {
  final pos = await Geolocator.getCurrentPosition(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      timeLimit: Duration(seconds: 15),
    ),
  );
  return LocationResult(latitude: pos.latitude, longitude: pos.longitude);
}

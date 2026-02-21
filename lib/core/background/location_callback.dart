import 'package:geolocator/geolocator.dart';

import '../../domain/location/location_service.dart';

/// Gets current position in background (used from WorkManager isolate).
/// Uses Geolocator directly so we don't depend on injected LocationService.
Future<LocationResult> getCurrentPositionInBackground() async {
  final pos = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
    timeLimit: const Duration(seconds: 10),
  );
  return LocationResult(latitude: pos.latitude, longitude: pos.longitude);
}

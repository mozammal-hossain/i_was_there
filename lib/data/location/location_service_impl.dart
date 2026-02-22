import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../domain/location/location_service.dart';

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  @override
  Future<LocationResult> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them in settings.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception(
        permission == LocationPermission.deniedForever
            ? 'Location permission permanently denied. Enable it in app settings.'
            : 'Location permission denied.',
      );
    }
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
    return LocationResult(latitude: pos.latitude, longitude: pos.longitude);
  }
}

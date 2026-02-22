import 'package:geolocator/geolocator.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/location/location_service.dart';

@LazySingleton(as: LocationService)
class LocationServiceImpl implements LocationService {
  @override
  Future<LocationResult> getCurrentPosition() async {
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      timeLimit: const Duration(seconds: 10),
    );
    return LocationResult(latitude: pos.latitude, longitude: pos.longitude);
  }
}

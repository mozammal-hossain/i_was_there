import 'package:geocoding/geocoding.dart';
import 'package:injectable/injectable.dart';

import '../../domain/location/current_location_result.dart';
import '../../domain/location/geocoding_service.dart';

@LazySingleton(as: GeocodingService)
class GeocodingServiceImpl implements GeocodingService {
  @override
  Future<String?> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final parts = [
        if (p.street?.isNotEmpty == true) p.street,
        if (p.locality?.isNotEmpty == true) p.locality,
        if (p.administrativeArea?.isNotEmpty == true) p.administrativeArea,
        if (p.country?.isNotEmpty == true) p.country,
      ];
      return parts.isEmpty ? null : parts.join(', ');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CurrentLocationResult?> getLocationFromAddress(String address) async {
    final query = address.trim();
    if (query.isEmpty) return null;
    try {
      final locations = await locationFromAddress(query);
      if (locations.isEmpty) return null;
      final loc = locations.first;
      final displayAddress =
          await getAddressFromCoordinates(loc.latitude, loc.longitude);
      return CurrentLocationResult(
        latitude: loc.latitude,
        longitude: loc.longitude,
        address: displayAddress ?? query,
      );
    } catch (_) {
      return null;
    }
  }
}

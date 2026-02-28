import 'package:injectable/injectable.dart';

import '../current_location_result.dart';
import '../geocoding_service.dart';

/// Use case: reverse geocode coordinates to a display address.
/// Returns [CurrentLocationResult] with the given coordinates and resolved address (or null if unavailable).
@injectable
class GetLocationFromCoordinatesUseCase {
  GetLocationFromCoordinatesUseCase(this._geocodingService);

  final GeocodingService _geocodingService;

  Future<CurrentLocationResult> call(double latitude, double longitude) async {
    final address = await _geocodingService.getAddressFromCoordinates(
      latitude,
      longitude,
    );
    return CurrentLocationResult(
      latitude: latitude,
      longitude: longitude,
      address: address,
    );
  }
}

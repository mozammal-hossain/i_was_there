import 'package:injectable/injectable.dart';

import '../current_location_result.dart';
import '../geocoding_service.dart';
import '../location_service.dart';

/// Use case: get current device location and optionally reverse-geocode to address.
/// Uses [LocationService] and [GeocodingService]; throws on permission/location errors.
@injectable
class GetCurrentLocationWithAddressUseCase {
  GetCurrentLocationWithAddressUseCase(
    this._locationService,
    this._geocodingService,
  );

  final LocationService _locationService;
  final GeocodingService _geocodingService;

  Future<CurrentLocationResult> call() async {
    final result = await _locationService.getCurrentPosition();
    final address = await _geocodingService.getAddressFromCoordinates(
      result.latitude,
      result.longitude,
    );
    return CurrentLocationResult(
      latitude: result.latitude,
      longitude: result.longitude,
      address: address,
    );
  }
}

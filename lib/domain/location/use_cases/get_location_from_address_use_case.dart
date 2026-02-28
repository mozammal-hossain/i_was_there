import 'package:injectable/injectable.dart';

import '../current_location_result.dart';
import '../geocoding_service.dart';

/// Use case: forward geocode an address string to coordinates and a display address.
/// Returns null if the address cannot be resolved.
@injectable
class GetLocationFromAddressUseCase {
  GetLocationFromAddressUseCase(this._geocodingService);

  final GeocodingService _geocodingService;

  Future<CurrentLocationResult?> call(String address) async {
    return _geocodingService.getLocationFromAddress(address);
  }
}

import '../entities/place.dart';
import '../repositories/place_repository.dart';

class UpdatePlace {
  UpdatePlace(this._repository);

  final PlaceRepository _repository;

  Future<void> call(Place place) => _repository.updatePlace(place);
}

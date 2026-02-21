import '../entities/place.dart';
import '../repositories/place_repository.dart';

class GetPlaces {
  GetPlaces(this._repository);

  final PlaceRepository _repository;

  Future<List<Place>> call() => _repository.getPlaces();
}

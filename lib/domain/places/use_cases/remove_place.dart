import '../repositories/place_repository.dart';

class RemovePlace {
  RemovePlace(this._repository);

  final PlaceRepository _repository;

  Future<void> call(String id) => _repository.removePlace(id);
}

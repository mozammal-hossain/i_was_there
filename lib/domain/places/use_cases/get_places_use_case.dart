import 'package:injectable/injectable.dart';

import '../entities/place.dart';
import '../repositories/place_repository.dart';

@injectable
class GetPlacesUseCase {
  GetPlacesUseCase(this._repository);

  final PlaceRepository _repository;

  Future<List<Place>> call() => _repository.getPlaces();
}

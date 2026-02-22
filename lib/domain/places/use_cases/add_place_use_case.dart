import 'package:injectable/injectable.dart';

import '../entities/place.dart';
import '../repositories/place_repository.dart';

@injectable
class AddPlaceUseCase {
  AddPlaceUseCase(this._repository);

  final PlaceRepository _repository;

  Future<void> call(Place place) => _repository.addPlace(place);
}

import 'package:injectable/injectable.dart';

import '../repositories/place_repository.dart';

@injectable
class RemovePlaceUseCase {
  RemovePlaceUseCase(this._repository);

  final PlaceRepository _repository;

  Future<void> call(String id) => _repository.removePlace(id);
}

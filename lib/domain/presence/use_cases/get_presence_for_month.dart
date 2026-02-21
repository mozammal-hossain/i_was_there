import '../entities/presence.dart';
import '../repositories/presence_repository.dart';

class GetPresenceForMonth {
  GetPresenceForMonth(this._repository);

  final PresenceRepository _repository;

  Future<List<Presence>> call(String placeId, int year, int month) =>
      _repository.getPresenceForMonth(placeId, year, month);
}

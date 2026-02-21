import '../entities/presence.dart';
import '../repositories/presence_repository.dart';

class GetPresencesForDay {
  GetPresencesForDay(this._repository);

  final PresenceRepository _repository;

  Future<List<Presence>> call(DateTime date) => _repository.getPresencesForDay(date);
}

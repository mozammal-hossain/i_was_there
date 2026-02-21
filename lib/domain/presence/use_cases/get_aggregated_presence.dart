import '../repositories/presence_repository.dart';

class GetAggregatedPresence {
  GetAggregatedPresence(this._repository);

  final PresenceRepository _repository;

  Future<Map<DateTime, bool>> call(DateTime start, DateTime end) =>
      _repository.getAggregatedPresenceInRange(start, end);
}

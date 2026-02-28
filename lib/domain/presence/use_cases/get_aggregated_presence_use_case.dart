import 'package:injectable/injectable.dart';

import '../repositories/presence_repository.dart';

@injectable
class GetAggregatedPresenceUseCase {
  GetAggregatedPresenceUseCase(this._repository);

  final PresenceRepository _repository;

  Future<Map<DateTime, bool>> call(DateTime start, DateTime end) =>
      _repository.getAggregatedPresenceInRange(start, end);
}

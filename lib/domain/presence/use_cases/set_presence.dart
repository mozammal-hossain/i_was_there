import 'package:injectable/injectable.dart';

import '../entities/presence.dart';
import '../repositories/presence_repository.dart';

@injectable
class SetPresence {
  SetPresence(this._repository);

  final PresenceRepository _repository;

  Future<void> call({
    required String placeId,
    required DateTime date,
    required bool isPresent,
    required PresenceSource source,
    DateTime? firstDetectedAt,
  }) => _repository.setPresence(
    placeId: placeId,
    date: date,
    isPresent: isPresent,
    source: source,
    firstDetectedAt: firstDetectedAt,
  );
}

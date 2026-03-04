import 'package:injectable/injectable.dart';

import '../../sync/use_cases/delete_calendar_event_use_case.dart';
import '../entities/presence.dart';
import '../repositories/presence_repository.dart';

@injectable
class SetPresenceUseCase {
  SetPresenceUseCase(this._repository, this._deleteCalendarEvent);

  final PresenceRepository _repository;
  final DeleteCalendarEventUseCase _deleteCalendarEvent;

  Future<void> call({
    required String placeId,
    required DateTime date,
    required bool isPresent,
    required PresenceSource source,
    DateTime? firstDetectedAt,
  }) async {
    await _repository.setPresence(
      placeId: placeId,
      date: date,
      isPresent: isPresent,
      source: source,
      firstDetectedAt: firstDetectedAt,
    );

    if (!isPresent) {
      // If marked not present, remove from Google Calendar if it was synced.
      await _deleteCalendarEvent.call(placeId, date);
    }
  }
}

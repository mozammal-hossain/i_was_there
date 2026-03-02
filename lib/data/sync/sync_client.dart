import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

import '../../domain/sync/calendar_sync_service.dart';
import '../../domain/sync/google_auth_service.dart';

@LazySingleton(as: CalendarSyncService)
class SyncClient implements CalendarSyncService {
  SyncClient(this._googleAuthService);

  final GoogleAuthService _googleAuthService;

  Future<http.Client> _getAuthenticatedClient() async {
    final headers = await _googleAuthService.getAuthHeaders();
    return _AuthenticatedHttpClient(headers);
  }

  @override
  Future<String> createEvent({
    required String placeName,
    required DateTime date,
    DateTime? firstDetectedAt,
  }) async {
    final client = await _getAuthenticatedClient();
    final calendarApi = calendar.CalendarApi(client);

    // Determine event start time: use firstDetectedAt if available, otherwise noon on the date
    final eventStart =
        firstDetectedAt ?? DateTime(date.year, date.month, date.day, 12, 0);
    final eventEnd = eventStart.add(const Duration(hours: 1));

    final event = calendar.Event(
      summary: 'Present at $placeName',
      start: calendar.EventDateTime(dateTime: eventStart),
      end: calendar.EventDateTime(dateTime: eventEnd),
    );

    final createdEvent = await calendarApi.events.insert(event, 'primary');

    if (createdEvent.id == null) {
      throw Exception('Failed to create calendar event');
    }

    return createdEvent.id!;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    final client = await _getAuthenticatedClient();
    final calendarApi = calendar.CalendarApi(client);

    await calendarApi.events.delete('primary', eventId);
  }
}

class _AuthenticatedHttpClient extends http.BaseClient {
  _AuthenticatedHttpClient(this._headers);

  final Map<String, String> _headers;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return http.Client().send(request);
  }
}

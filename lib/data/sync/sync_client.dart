import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../core/logging.dart';

import '../../domain/sync/calendar_sync_service.dart';

@LazySingleton(as: CalendarSyncService)
class SyncClient implements CalendarSyncService {
  SyncClient(this._dio);

  final Dio _dio;

  @override
  Future<String> createEvent({
    required String placeName,
    required DateTime date,
    DateTime? firstDetectedAt,
  }) async {
    // Determine event start time: use firstDetectedAt if available, otherwise noon on the date
    final eventStart =
        firstDetectedAt ?? DateTime(date.year, date.month, date.day, 12, 0);
    final eventEnd = eventStart.add(const Duration(hours: 1));

    // Build request payload according to Google Calendar API v3.
    final body = {
      'summary': 'Present at $placeName',
      'start': {'dateTime': eventStart.toUtc().toIso8601String()},
      'end': {'dateTime': eventEnd.toUtc().toIso8601String()},
    };

    appLogger.i('Creating calendar event: $body');
    final response = await _dio.post(
      'https://www.googleapis.com/calendar/v3/calendars/primary/events',
      data: body,
    );
    appLogger.d('Calendar API returned ${response.statusCode}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      appLogger.e(
        'Create event failed: ${response.statusCode} ${response.data}',
      );
      throw Exception(
        'Failed to create calendar event: ${response.statusCode} ${response.data}',
      );
    }

    final eventId = response.data['id'] as String?;
    if (eventId == null) {
      appLogger.e('Response did not contain event id: ${response.data}');
      throw Exception('Failed to parse event id from response');
    }

    return eventId;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    appLogger.i('Deleting calendar event $eventId');
    final response = await _dio.delete(
      'https://www.googleapis.com/calendar/v3/calendars/primary/events/$eventId',
    );
    appLogger.d('Delete response status: ${response.statusCode}');

    if (response.statusCode != 204 && response.statusCode != 200) {
      appLogger.e('Delete failed: ${response.statusCode} ${response.data}');
      throw Exception(
        'Failed to delete calendar event: ${response.statusCode} ${response.data}',
      );
    }
  }
}

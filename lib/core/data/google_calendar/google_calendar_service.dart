import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:http/http.dart' as http;
import '../../../domain/sync/google_auth_service.dart';

class GoogleCalendarService {
  final GoogleAuthService _googleAuthService;
  calendar.CalendarApi? _calendarApi;

  GoogleCalendarService(this._googleAuthService);

  Future<bool> ensureSignedIn() async {
    final account = await _googleAuthService.getCurrentAccount();
    if (account == null) return false;
    final headers = await _googleAuthService.getAuthHeaders();
    final client = _GoogleAuthClient(headers);
    _calendarApi = calendar.CalendarApi(client);
    return true;
  }

  Future<List<calendar.Event>> getUpcomingEvents({int maxResults = 10}) async {
    if (_calendarApi == null) {
      final ok = await ensureSignedIn();
      if (!ok) throw Exception('Not signed in');
    }
    final events = await _calendarApi!.events.list(
      "primary",
      maxResults: maxResults,
      orderBy: 'startTime',
      singleEvents: true,
      timeMin: DateTime.now().toUtc(),
    );
    return events.items ?? [];
  }
}

class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}

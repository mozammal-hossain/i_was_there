import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:injectable/injectable.dart';

import '../../core/logging.dart';

import '../../domain/sync/entities/google_account_info.dart';
import '../../domain/sync/google_auth_service.dart';

@LazySingleton(as: GoogleAuthService)
class GoogleAuthServiceImpl implements GoogleAuthService {
  final List<String> _scopes = [calendar.CalendarApi.calendarScope];
  late final GoogleSignIn _googleSignIn;
  GoogleSignInAccount? _currentAccount;

  GoogleAuthServiceImpl() {
    // Use the singleton instance; scopes are supplied when performing
    // authentication so that we can request calendar access lazily.
    _googleSignIn = GoogleSignIn.instance;
    // Subscribe to auth events to track current account
    _googleSignIn.authenticationEvents.listen((event) {
      _currentAccount = switch (event) {
        GoogleSignInAuthenticationEventSignIn(:final user) => user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };
    });
  }

  @override
  Future<GoogleAccountInfo?> signIn() async {
    // allow exceptions to bubble up so callers can display an error
    // supply calendar scope hint to the authentication flow
    appLogger.d('Attempting Google sign-in with scopes: $_scopes');
    final account = await _googleSignIn.authenticate(scopeHint: _scopes);

    _currentAccount = account;
    appLogger.i('Signed in as ${account.email}');

    return GoogleAccountInfo(
      displayName: account.displayName,
      email: account.email,
    );
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentAccount = null;
  }

  @override
  Future<GoogleAccountInfo?> getCurrentAccount() async {
    try {
      if (_currentAccount != null) {
        return GoogleAccountInfo(
          displayName: _currentAccount!.displayName,
          email: _currentAccount!.email,
        );
      }

      // Try lightweight authentication for cached user
      final account = await _googleSignIn.attemptLightweightAuthentication();

      if (account == null) return null;

      _currentAccount = account;
      appLogger.d('Lightweight auth returned ${account.email}');

      return GoogleAccountInfo(
        displayName: account.displayName,
        email: account.email,
      );
    } catch (e) {
      appLogger.w('Error getting current Google account', error: e);
      return null;
    }
  }

  @override
  Future<Map<String, String>> getAuthHeaders() async {
    try {
      if (_currentAccount == null) {
        throw Exception('Not signed in');
      }

      final headers = await _currentAccount!.authorizationClient
          .authorizationHeaders(_scopes);

      if (headers == null) {
        throw Exception('Could not get auth headers');
      }

      appLogger.d('Obtained auth headers');
      return headers;
    } catch (e) {
      appLogger.e('Failed to get auth headers', error: e);
      throw Exception('Failed to get auth headers: $e');
    }
  }
}

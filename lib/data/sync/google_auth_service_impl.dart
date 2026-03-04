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
  late final Future<void> _initFuture;
  GoogleSignInAccount? _currentAccount;

  static const _reauthErrorSubtitle = 'reauth';

  GoogleAuthServiceImpl() {
    // Use the singleton instance; scopes are supplied when performing
    // authentication so that we can request calendar access lazily.
    _googleSignIn = GoogleSignIn.instance;
    _initFuture = _googleSignIn.initialize();
  }

  Future<void> _ensureInitialized() async {
    await _initFuture;
    // Subscribe to auth events after initialize() completes (stream is set up there)
    _googleSignIn.authenticationEvents.listen((event) {
      _currentAccount = switch (event) {
        GoogleSignInAuthenticationEventSignIn(:final user) => user,
        GoogleSignInAuthenticationEventSignOut() => null,
      };
    });
  }

  @override
  Future<GoogleAccountInfo?> signIn() async {
    await _ensureInitialized();
    // allow exceptions to bubble up so callers can display an error
    // supply calendar scope hint to the authentication flow
    appLogger.d('Attempting Google sign-in with scopes: $_scopes');
    try {
      final account = await _googleSignIn.authenticate(scopeHint: _scopes);
      _currentAccount = account;
      appLogger.i('Signed in as ${account.email}');
      return GoogleAccountInfo(
        displayName: account.displayName,
        email: account.email,
      );
    } on GoogleSignInException catch (e, st) {
      appLogger.w('Google sign-in failed', error: e, stackTrace: st);
      if (e.code == GoogleSignInExceptionCode.canceled) {
        // Error code [16] "Account reauth failed" is surfaced as `canceled`
        // by the plugin, but it is NOT a real user cancellation — it means
        // the Credential Manager couldn't silently re-authenticate and the
        // user must sign in again interactively.
        final isReauthFailure =
            e.description?.toLowerCase().contains(_reauthErrorSubtitle) ??
            false;
        if (isReauthFailure) {
          appLogger.w('Reauth failed — clearing credentials and retrying');
          // Clear stale credential so the next authenticate() shows the
          // full account picker (sign-up / add-account flow).
          await _googleSignIn.signOut();
          try {
            final retryAccount = await _googleSignIn.authenticate(
              scopeHint: _scopes,
            );
            _currentAccount = retryAccount;
            appLogger.i('Signed in (retry) as ${retryAccount.email}');
            return GoogleAccountInfo(
              displayName: retryAccount.displayName,
              email: retryAccount.email,
            );
          } catch (retryError, retrySt) {
            appLogger.e(
              'Retry sign-in also failed',
              error: retryError,
              stackTrace: retrySt,
            );
            rethrow;
          }
        }
        // Genuine user cancellation — treat as null result
        return null;
      }
      // For other errors, rethrow
      rethrow;
    } catch (e, st) {
      appLogger.e(
        'Unexpected error during Google sign-in',
        error: e,
        stackTrace: st,
      );
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _ensureInitialized();
    await _googleSignIn.signOut();
    _currentAccount = null;
  }

  @override
  Future<void> disconnect() async {
    await _ensureInitialized();
    await _googleSignIn.disconnect();
    _currentAccount = null;
  }

  @override
  Future<GoogleAccountInfo?> getCurrentAccount() async {
    await _ensureInitialized();
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
    await _ensureInitialized();
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

import 'entities/google_account_info.dart';

abstract class GoogleAuthService {
  /// Triggers interactive Google Sign-In with Calendar scope.
  /// Returns account info on success, null if user cancelled.
  Future<GoogleAccountInfo?> signIn();

  /// Signs out and revokes Calendar access.
  Future<void> signOut();

  /// Revokes Google access and signs out.
  Future<void> disconnect();

  /// Returns the currently signed-in account (silent/cached check).
  /// Returns null if not signed in.
  Future<GoogleAccountInfo?> getCurrentAccount();

  /// Returns auth headers for authenticated HTTP requests to Google APIs.
  /// Throws if not signed in.
  Future<Map<String, String>> getAuthHeaders();
}

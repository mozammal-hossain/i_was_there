class SettingsState {
  const SettingsState({
    this.syncEnabled = true,
    this.loading = true,
    this.errorMessage,
    this.lastSyncTime,
    this.googleDisplayName,
    this.googleEmail,
    this.isSyncing = false,
    this.signInError,
  });

  final bool syncEnabled;
  final bool loading;
  final String? errorMessage;
  final DateTime? lastSyncTime;
  final String? googleDisplayName;
  final String? googleEmail;
  final bool isSyncing;
  final String? signInError;

  // sentinel objects used to differentiate between "no argument provided"
  // and "explicitly pass null" when calling [copyWith].  this lets callers
  // clear the google account fields by providing `googleDisplayName: null`
  // without losing the ability to keep the existing value when they don't
  // touch it.
  static const _undefined = Object();

  SettingsState copyWith({
    bool? syncEnabled,
    bool? loading,
    String? errorMessage,
    DateTime? lastSyncTime,
    Object? googleDisplayName = _undefined,
    Object? googleEmail = _undefined,
    bool? isSyncing,
    String? signInError,
  }) {
    return SettingsState(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      googleDisplayName: identical(googleDisplayName, _undefined)
          ? this.googleDisplayName
          : googleDisplayName as String?,
      googleEmail: identical(googleEmail, _undefined)
          ? this.googleEmail
          : googleEmail as String?,
      isSyncing: isSyncing ?? this.isSyncing,
      signInError: signInError,
    );
  }
}

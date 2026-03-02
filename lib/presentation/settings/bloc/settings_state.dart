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

  SettingsState copyWith({
    bool? syncEnabled,
    bool? loading,
    String? errorMessage,
    DateTime? lastSyncTime,
    String? googleDisplayName,
    String? googleEmail,
    bool? isSyncing,
    String? signInError,
  }) {
    return SettingsState(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      googleDisplayName: googleDisplayName ?? this.googleDisplayName,
      googleEmail: googleEmail ?? this.googleEmail,
      isSyncing: isSyncing ?? this.isSyncing,
      signInError: signInError,
    );
  }
}

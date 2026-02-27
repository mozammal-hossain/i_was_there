class SettingsState {
  const SettingsState({
    this.syncEnabled = true,
    this.loading = true,
    this.errorMessage,
    this.lastSyncTime,
  });

  final bool syncEnabled;
  final bool loading;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  SettingsState copyWith({
    bool? syncEnabled,
    bool? loading,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return SettingsState(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

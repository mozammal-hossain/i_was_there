class SettingsState {
  const SettingsState({
    this.syncEnabled = true,
    this.loading = true,
    this.errorMessage,
  });

  final bool syncEnabled;
  final bool loading;
  final String? errorMessage;

  SettingsState copyWith({
    bool? syncEnabled,
    bool? loading,
    String? errorMessage,
  }) {
    return SettingsState(
      syncEnabled: syncEnabled ?? this.syncEnabled,
      loading: loading ?? this.loading,
      errorMessage: errorMessage,
    );
  }
}

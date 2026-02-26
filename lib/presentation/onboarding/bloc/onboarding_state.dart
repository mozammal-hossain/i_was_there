class OnboardingState {
  const OnboardingState({
    this.step = 0,
    this.calendarSyncEnabled = true,
    this.completeRequested = false,
  });

  final int step;
  final bool calendarSyncEnabled;
  final bool completeRequested;

  OnboardingState copyWith({
    int? step,
    bool? calendarSyncEnabled,
    bool? completeRequested,
  }) {
    return OnboardingState(
      step: step ?? this.step,
      calendarSyncEnabled: calendarSyncEnabled ?? this.calendarSyncEnabled,
      completeRequested: completeRequested ?? this.completeRequested,
    );
  }
}

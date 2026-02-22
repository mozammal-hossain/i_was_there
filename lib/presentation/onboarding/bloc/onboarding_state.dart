class OnboardingState {
  const OnboardingState({this.step = 0});

  final int step;

  OnboardingState copyWith({int? step}) {
    return OnboardingState(step: step ?? this.step);
  }
}

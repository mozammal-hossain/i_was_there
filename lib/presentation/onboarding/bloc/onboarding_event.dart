abstract class OnboardingEvent {}

class OnboardingStarted extends OnboardingEvent {}

class OnboardingNextStep extends OnboardingEvent {}

class OnboardingBack extends OnboardingEvent {}

class OnboardingComplete extends OnboardingEvent {}

class OnboardingMaybeLater extends OnboardingEvent {}

class OnboardingCalendarSyncToggled extends OnboardingEvent {
  OnboardingCalendarSyncToggled(this.enabled);
  final bool enabled;
}

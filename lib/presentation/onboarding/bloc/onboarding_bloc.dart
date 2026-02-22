import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingNextStep>(_onNextStep);
    on<OnboardingComplete>(_onComplete);
  }

  void _onNextStep(OnboardingNextStep event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(step: state.step + 1));
  }

  void _onComplete(OnboardingComplete event, Emitter<OnboardingState> emit) {
    // Completion is handled by the feature (callback to router). No state change needed.
  }
}

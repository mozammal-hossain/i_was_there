import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import '../../../../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({
    required GetCalendarSyncEnabledUseCase getCalendarSyncEnabled,
    required SetCalendarSyncEnabledUseCase setCalendarSyncEnabled,
  })  : _getCalendarSyncEnabled = getCalendarSyncEnabled,
        _setCalendarSyncEnabled = setCalendarSyncEnabled,
        super(const OnboardingState()) {
    on<OnboardingStarted>(_onStarted);
    on<OnboardingNextStep>(_onNextStep);
    on<OnboardingBack>(_onBack);
    on<OnboardingComplete>(_onComplete);
    on<OnboardingMaybeLater>(_onMaybeLater);
    on<OnboardingCalendarSyncToggled>(_onCalendarSyncToggled);
  }

  final GetCalendarSyncEnabledUseCase _getCalendarSyncEnabled;
  final SetCalendarSyncEnabledUseCase _setCalendarSyncEnabled;

  Future<void> _onStarted(
      OnboardingStarted event, Emitter<OnboardingState> emit) async {
    try {
      final enabled = await _getCalendarSyncEnabled();
      emit(state.copyWith(calendarSyncEnabled: enabled));
    } catch (_) {
      emit(state.copyWith(calendarSyncEnabled: true));
    }
  }

  void _onNextStep(OnboardingNextStep event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(step: state.step + 1));
  }

  void _onBack(OnboardingBack event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(step: 0));
  }

  void _onComplete(OnboardingComplete event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(completeRequested: true));
  }

  void _onMaybeLater(OnboardingMaybeLater event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(completeRequested: true));
  }

  Future<void> _onCalendarSyncToggled(
      OnboardingCalendarSyncToggled event, Emitter<OnboardingState> emit) async {
    await _setCalendarSyncEnabled(event.enabled);
    emit(state.copyWith(calendarSyncEnabled: event.enabled));
  }
}

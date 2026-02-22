import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/places/use_cases/get_places.dart';
import '../../../../domain/presence/use_cases/get_aggregated_presence.dart';
import '../../../../domain/presence/use_cases/get_presences_for_day.dart';
import '../../../../domain/presence/use_cases/set_presence.dart';
import '../../../../domain/presence/entities/presence.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required GetPlaces getPlaces,
    required GetAggregatedPresence getAggregatedPresence,
    required GetPresencesForDay getPresencesForDay,
    required SetPresence setPresence,
  })  : _getPlaces = getPlaces,
        _getAggregatedPresence = getAggregatedPresence,
        _getPresencesForDay = getPresencesForDay,
        _setPresence = setPresence,
        super(const CalendarState()) {
    on<CalendarLoadRequested>(_onLoad);
    on<CalendarMonthChanged>(_onMonthChanged);
    on<CalendarDaySelected>(_onDaySelected);
    on<CalendarManualPresenceApplied>(_onManualPresenceApplied);
  }

  final GetPlaces _getPlaces;
  final GetAggregatedPresence _getAggregatedPresence;
  final GetPresencesForDay _getPresencesForDay;
  final SetPresence _setPresence;

  Future<void> _onLoad(
      CalendarLoadRequested event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(loadingPlaces: true, errorMessage: null));
    try {
      final places = await _getPlaces.call();
      final month = state.effectiveViewMonth;
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0);
      final presenceByDay =
          await _getAggregatedPresence.call(start, end);
      emit(state.copyWith(
        places: places,
        loadingPlaces: false,
        viewMonth: month,
        presenceByDay: presenceByDay,
        loadingPresence: false,
        errorMessage: null,
      ));
    } catch (e, _) {
      emit(state.copyWith(
        loadingPlaces: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onMonthChanged(
      CalendarMonthChanged event, Emitter<CalendarState> emit) async {
    emit(state.copyWith(
      viewMonth: event.month,
      selectedDay: null,
      dayPresences: [],
      loadingPresence: true,
    ));
    try {
      final start = DateTime(event.month.year, event.month.month, 1);
      final end = DateTime(event.month.year, event.month.month + 1, 0);
      final presenceByDay =
          await _getAggregatedPresence.call(start, end);
      emit(state.copyWith(
        presenceByDay: presenceByDay,
        loadingPresence: false,
      ));
    } catch (e, _) {
      emit(state.copyWith(
        loadingPresence: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onDaySelected(
      CalendarDaySelected event, Emitter<CalendarState> emit) async {
    if (event.day == null) {
      emit(state.copyWith(selectedDay: null, dayPresences: []));
      return;
    }
    emit(state.copyWith(
      selectedDay: event.day,
      loadingDayDetails: true,
    ));
    try {
      final date = DateTime(
        state.effectiveViewMonth.year,
        state.effectiveViewMonth.month,
        event.day!,
      );
      final list = await _getPresencesForDay.call(date);
      emit(state.copyWith(
        dayPresences: list,
        loadingDayDetails: false,
      ));
    } catch (e, _) {
      emit(state.copyWith(
        loadingDayDetails: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onManualPresenceApplied(
      CalendarManualPresenceApplied event, Emitter<CalendarState> emit) async {
    try {
      for (final entry in event.presence.entries) {
        await _setPresence.call(
          placeId: entry.key,
          date: event.date,
          isPresent: entry.value,
          source: PresenceSource.manual,
        );
      }
      final month = state.effectiveViewMonth;
      final start = DateTime(month.year, month.month, 1);
      final end = DateTime(month.year, month.month + 1, 0);
      final presenceByDay =
          await _getAggregatedPresence.call(start, end);
      final selectedDay = state.selectedDay;
      List<Presence> dayPresences = state.dayPresences;
      if (selectedDay != null) {
        final date = DateTime(month.year, month.month, selectedDay);
        dayPresences = await _getPresencesForDay.call(date);
      }
      emit(state.copyWith(
        presenceByDay: presenceByDay,
        dayPresences: dayPresences,
        errorMessage: null,
      ));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

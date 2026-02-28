import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/places/use_cases/get_places_use_case.dart';
import '../../../../domain/presence/use_cases/get_presence_for_month_use_case.dart';
import '../../../../domain/presence/use_cases/get_presences_for_day_use_case.dart';
import '../../../../domain/presence/use_cases/set_presence_use_case.dart';
import '../../../../domain/presence/entities/presence.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required GetPlacesUseCase getPlaces,
    required GetPresenceForMonthUseCase getPresenceForMonth,
    required GetPresencesForDayUseCase getPresencesForDay,
    required SetPresenceUseCase setPresence,
  }) : _getPlaces = getPlaces,
       _getPresenceForMonth = getPresenceForMonth,
       _getPresencesForDay = getPresencesForDay,
       _setPresence = setPresence,
       super(const HistoryState()) {
    on<HistoryLoadRequested>(_onLoad);
    on<HistoryMonthChanged>(_onMonthChanged);
    on<HistoryDaySelected>(_onDaySelected);
    on<HistoryFilterChanged>(_onFilterChanged);
    on<HistoryManualPresenceApplied>(_onManualPresenceApplied);
  }

  final GetPlacesUseCase _getPlaces;
  final GetPresenceForMonthUseCase _getPresenceForMonth;
  final GetPresencesForDayUseCase _getPresencesForDay;
  final SetPresenceUseCase _setPresence;

  /// Returns a detailed per-place presence map for every day in [month].
  /// Outer key is the date at midnight; inner map maps placeId -> isPresent.
  /// Days with no data default to `{}` so callers can treat missing entries as
  /// `false` when necessary.
  Future<Map<DateTime, Map<String, bool>>> _loadPresenceByPlaceForMonth(
    DateTime month,
  ) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    final map = <DateTime, Map<String, bool>>{};
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      map[d] = {};
    }
    // load presence for each tracked place
    final places = await _getPlaces.call();
    for (final place in places) {
      final list = await _getPresenceForMonth.call(
        place.id,
        month.year,
        month.month,
      );
      for (final p in list) {
        final day = DateTime(p.date.year, p.date.month, p.date.day);
        if (map.containsKey(day)) {
          map[day]![place.id] = p.isPresent;
        }
      }
    }
    return map;
  }

  /// Aggregate a per-place map into the boolean presence indication used by
  /// the UI. When [filterPlaceId] is provided, only that place contributes to
  /// the result; otherwise any true value counts.
  Map<DateTime, bool> _aggregatePresence(
    Map<DateTime, Map<String, bool>> byPlace,
    String? filterPlaceId,
  ) {
    final out = <DateTime, bool>{};
    byPlace.forEach((date, inner) {
      if (filterPlaceId == null) {
        out[date] = inner.values.any((b) => b);
      } else {
        out[date] = inner[filterPlaceId] ?? false;
      }
    });
    return out;
  }

  Future<void> _onLoad(
    HistoryLoadRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(loadingPlaces: true, errorMessage: null));
    try {
      final places = await _getPlaces.call();
      final month = state.effectiveViewMonth;
      final byPlace = await _loadPresenceByPlaceForMonth(month);
      final aggregated = _aggregatePresence(byPlace, state.selectedPlaceId);
      emit(
        state.copyWith(
          places: places,
          loadingPlaces: false,
          viewMonth: month,
          presenceByDay: aggregated,
          presenceByDayPerPlace: byPlace,
          loadingPresence: false,
          errorMessage: null,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(loadingPlaces: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onMonthChanged(
    HistoryMonthChanged event,
    Emitter<HistoryState> emit,
  ) async {
    emit(
      state.copyWith(
        viewMonth: event.month,
        selectedDay: null,
        dayPresences: [],
        loadingPresence: true,
      ),
    );
    try {
      final byPlace = await _loadPresenceByPlaceForMonth(event.month);
      final aggregated = _aggregatePresence(byPlace, state.selectedPlaceId);
      emit(
        state.copyWith(
          presenceByDay: aggregated,
          presenceByDayPerPlace: byPlace,
          loadingPresence: false,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(loadingPresence: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onDaySelected(
    HistoryDaySelected event,
    Emitter<HistoryState> emit,
  ) async {
    if (event.day == null) {
      emit(state.copyWith(selectedDay: null, dayPresences: []));
      return;
    }
    emit(state.copyWith(selectedDay: event.day, loadingDayDetails: true));
    try {
      final date = DateTime(
        state.effectiveViewMonth.year,
        state.effectiveViewMonth.month,
        event.day!,
      );
      final list = await _getPresencesForDay.call(date);
      emit(
        state.copyWith(
          selectedDay: event.day,
          dayPresences: list,
          loadingDayDetails: false,
        ),
      );
    } catch (e, _) {
      emit(
        state.copyWith(
          selectedDay: event.day,
          loadingDayDetails: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFilterChanged(
    HistoryFilterChanged event,
    Emitter<HistoryState> emit,
  ) async {
    // just update filter and recompute using cached per-place map
    emit(state.copyWith(selectedPlaceId: event.placeId, loadingPresence: true));
    final aggregated = _aggregatePresence(
      state.presenceByDayPerPlace,
      event.placeId,
    );
    emit(
      state.copyWith(
        presenceByDay: aggregated,
        loadingPresence: false,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onManualPresenceApplied(
    HistoryManualPresenceApplied event,
    Emitter<HistoryState> emit,
  ) async {
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
      final byPlace = await _loadPresenceByPlaceForMonth(month);
      final aggregated = _aggregatePresence(byPlace, state.selectedPlaceId);
      final selectedDay = state.selectedDay;
      List<Presence> dayPresences = state.dayPresences;
      if (selectedDay != null) {
        final date = DateTime(month.year, month.month, selectedDay);
        dayPresences = await _getPresencesForDay.call(date);
      }
      emit(
        state.copyWith(
          presenceByDay: aggregated,
          presenceByDayPerPlace: byPlace,
          dayPresences: dayPresences,
          errorMessage: null,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

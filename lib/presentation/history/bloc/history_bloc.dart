import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/places/use_cases/get_places_use_case.dart';
import '../../../../domain/presence/use_cases/get_aggregated_presence_use_case.dart';
import '../../../../domain/presence/use_cases/get_presence_for_month_use_case.dart';
import '../../../../domain/presence/use_cases/get_presences_for_day_use_case.dart';
import '../../../../domain/presence/use_cases/set_presence_use_case.dart';
import '../../../../domain/presence/entities/presence.dart';
import 'history_event.dart';
import 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc({
    required GetPlacesUseCase getPlaces,
    required GetAggregatedPresenceUseCase getAggregatedPresence,
    required GetPresenceForMonthUseCase getPresenceForMonth,
    required GetPresencesForDayUseCase getPresencesForDay,
    required SetPresenceUseCase setPresence,
  })  : _getPlaces = getPlaces,
        _getAggregatedPresence = getAggregatedPresence,
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
  final GetAggregatedPresenceUseCase _getAggregatedPresence;
  final GetPresenceForMonthUseCase _getPresenceForMonth;
  final GetPresencesForDayUseCase _getPresencesForDay;
  final SetPresenceUseCase _setPresence;

  /// Loads presence for the given month. If [placeId] is null, returns aggregated
  /// (any place); otherwise returns presence for that place only.
  Future<Map<DateTime, bool>> _loadPresenceForMonth(
    DateTime month,
    String? placeId,
  ) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0);
    if (placeId == null) {
      return _getAggregatedPresence.call(start, end);
    }
    final list = await _getPresenceForMonth.call(
      placeId,
      month.year,
      month.month,
    );
    final map = <DateTime, bool>{};
    for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
      map[d] = false;
    }
    for (final p in list) {
      if (p.isPresent) {
        final day = DateTime(p.date.year, p.date.month, p.date.day);
        if (map.containsKey(day)) map[day] = true;
      }
    }
    return map;
  }

  Future<void> _onLoad(
    HistoryLoadRequested event,
    Emitter<HistoryState> emit,
  ) async {
    emit(state.copyWith(loadingPlaces: true, errorMessage: null));
    try {
      final places = await _getPlaces.call();
      final month = state.effectiveViewMonth;
      final presenceByDay = await _loadPresenceForMonth(
        month,
        state.selectedPlaceId,
      );
      emit(
        state.copyWith(
          places: places,
          loadingPlaces: false,
          viewMonth: month,
          presenceByDay: presenceByDay,
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
      final presenceByDay = await _loadPresenceForMonth(
        event.month,
        state.selectedPlaceId,
      );
      emit(
        state.copyWith(presenceByDay: presenceByDay, loadingPresence: false),
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
        selectedDay: event.day,
        dayPresences: list,
        loadingDayDetails: false,
      ));
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
    emit(
      state.copyWith(
        selectedPlaceId: event.placeId,
        loadingPresence: true,
      ),
    );
    try {
      final month = state.effectiveViewMonth;
      final presenceByDay = await _loadPresenceForMonth(month, event.placeId);
      emit(
        state.copyWith(
          presenceByDay: presenceByDay,
          loadingPresence: false,
          errorMessage: null,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(loadingPresence: false, errorMessage: e.toString()));
    }
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
      final presenceByDay = await _loadPresenceForMonth(
        month,
        state.selectedPlaceId,
      );
      final selectedDay = state.selectedDay;
      List<Presence> dayPresences = state.dayPresences;
      if (selectedDay != null) {
        final date = DateTime(month.year, month.month, selectedDay);
        dayPresences = await _getPresencesForDay.call(date);
      }
      emit(
        state.copyWith(
          presenceByDay: presenceByDay,
          dayPresences: dayPresences,
          errorMessage: null,
        ),
      );
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

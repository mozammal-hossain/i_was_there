import '../../../../domain/places/entities/place.dart';
import '../../../../domain/presence/entities/presence.dart';

/// Sentinel for copyWith: omit [selectedPlaceId] to keep current value.
const _keepSelectedPlaceId = Object();

class HistoryState {
  const HistoryState({
    this.places = const [],
    this.loadingPlaces = true,
    this.viewMonth,
    this.presenceByDay = const {},
    this.presenceByDayPerPlace = const {},
    this.loadingPresence = false,
    this.selectedDay,
    this.dayPresences = const [],
    this.loadingDayDetails = false,
    this.selectedPlaceId,
    this.errorMessage,
  });

  final List<Place> places;
  final bool loadingPlaces;
  final DateTime? viewMonth;

  /// Aggregated presence bool (any place) for each date. Computed from
  /// [presenceByDayPerPlace] so callers can still consume the old API.
  final Map<DateTime, bool> presenceByDay;

  /// Detailed per-place presence for each date. Outer key is date at
  /// midnight, inner map maps placeId -> isPresent. This drives the
  /// multi-colored calendar cells and supports filtering.
  final Map<DateTime, Map<String, bool>> presenceByDayPerPlace;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final String? selectedPlaceId;
  final String? errorMessage;

  DateTime get effectiveViewMonth =>
      viewMonth ?? DateTime(DateTime.now().year, DateTime.now().month);

  HistoryState copyWith({
    List<Place>? places,
    bool? loadingPlaces,
    DateTime? viewMonth,
    Map<DateTime, bool>? presenceByDay,
    Map<DateTime, Map<String, bool>>? presenceByDayPerPlace,
    bool? loadingPresence,
    int? selectedDay,
    List<Presence>? dayPresences,
    bool? loadingDayDetails,
    Object? selectedPlaceId = _keepSelectedPlaceId,
    String? errorMessage,
  }) {
    return HistoryState(
      places: places ?? this.places,
      loadingPlaces: loadingPlaces ?? this.loadingPlaces,
      viewMonth: viewMonth ?? this.viewMonth,
      presenceByDay: presenceByDay ?? this.presenceByDay,
      presenceByDayPerPlace:
          presenceByDayPerPlace ?? this.presenceByDayPerPlace,
      loadingPresence: loadingPresence ?? this.loadingPresence,
      selectedDay: selectedDay,
      dayPresences: dayPresences ?? this.dayPresences,
      loadingDayDetails: loadingDayDetails ?? this.loadingDayDetails,
      selectedPlaceId: identical(selectedPlaceId, _keepSelectedPlaceId)
          ? this.selectedPlaceId
          : selectedPlaceId as String?,
      errorMessage: errorMessage,
    );
  }
}

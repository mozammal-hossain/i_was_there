import '../../../../domain/places/entities/place.dart';
import '../../../../domain/presence/entities/presence.dart';

class HistoryState {
  const HistoryState({
    this.places = const [],
    this.loadingPlaces = true,
    this.viewMonth,
    this.presenceByDay = const {},
    this.loadingPresence = false,
    this.selectedDay,
    this.dayPresences = const [],
    this.loadingDayDetails = false,
    this.errorMessage,
  });

  final List<Place> places;
  final bool loadingPlaces;
  final DateTime? viewMonth;
  final Map<DateTime, bool> presenceByDay;
  final bool loadingPresence;
  final int? selectedDay;
  final List<Presence> dayPresences;
  final bool loadingDayDetails;
  final String? errorMessage;

  DateTime get effectiveViewMonth =>
      viewMonth ?? DateTime(DateTime.now().year, DateTime.now().month);

  HistoryState copyWith({
    List<Place>? places,
    bool? loadingPlaces,
    DateTime? viewMonth,
    Map<DateTime, bool>? presenceByDay,
    bool? loadingPresence,
    int? selectedDay,
    List<Presence>? dayPresences,
    bool? loadingDayDetails,
    String? errorMessage,
  }) {
    return HistoryState(
      places: places ?? this.places,
      loadingPlaces: loadingPlaces ?? this.loadingPlaces,
      viewMonth: viewMonth ?? this.viewMonth,
      presenceByDay: presenceByDay ?? this.presenceByDay,
      loadingPresence: loadingPresence ?? this.loadingPresence,
      selectedDay: selectedDay,
      dayPresences: dayPresences ?? this.dayPresences,
      loadingDayDetails: loadingDayDetails ?? this.loadingDayDetails,
      errorMessage: errorMessage,
    );
  }
}

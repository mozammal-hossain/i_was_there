import '../../../../domain/places/entities/place.dart';

class DashboardState {
  const DashboardState({
    this.places = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Place> places;
  final bool isLoading;
  final String? errorMessage;

  bool get hasPlaces => places.isNotEmpty;

  DashboardState copyWith({
    List<Place>? places,
    bool? isLoading,
    String? errorMessage,
  }) {
    return DashboardState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

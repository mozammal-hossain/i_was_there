import '../../../../domain/places/entities/place.dart';

class PlacesState {
  const PlacesState({
    this.places = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  final List<Place> places;
  final bool isLoading;
  final String? errorMessage;

  bool get hasPlaces => places.isNotEmpty;

  PlacesState copyWith({
    List<Place>? places,
    bool? isLoading,
    String? errorMessage,
  }) {
    return PlacesState(
      places: places ?? this.places,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

import '../../../domain/location/current_location_result.dart';

/// State for the add/edit place page (CUSTOM_RULES: UI driven by Bloc state).
class AddEditPlaceState {
  const AddEditPlaceState({
    this.locationLoading = false,
    this.locationResult,
    this.locationError,
  });

  final bool locationLoading;
  final CurrentLocationResult? locationResult;
  final String? locationError;

  AddEditPlaceState copyWith({
    bool? locationLoading,
    CurrentLocationResult? locationResult,
    String? locationError,
  }) {
    return AddEditPlaceState(
      locationLoading: locationLoading ?? this.locationLoading,
      locationResult: locationResult ?? this.locationResult,
      locationError: locationError,
    );
  }
}

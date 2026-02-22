import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/location/use_cases/get_current_location_with_address_use_case.dart';
import '../../../domain/location/use_cases/get_location_from_address_use_case.dart';
import '../../../domain/location/use_cases/get_location_from_coordinates_use_case.dart';
import 'add_edit_place_event.dart';
import 'add_edit_place_state.dart';

/// BLoC for add/edit place page. Handles "use current location", address search, and map tap via use cases (CUSTOM_RULES).
class AddEditPlaceBloc extends Bloc<AddEditPlaceEvent, AddEditPlaceState> {
  AddEditPlaceBloc(
    this._getCurrentLocationWithAddress,
    this._getLocationFromAddress,
    this._getLocationFromCoordinates,
  ) : super(const AddEditPlaceState()) {
    on<AddEditPlaceUseCurrentLocationRequested>(_onUseCurrentLocationRequested);
    on<AddEditPlaceAddressSearchRequested>(_onAddressSearchRequested);
    on<AddEditPlaceMapLocationSelected>(_onMapLocationSelected);
  }

  final GetCurrentLocationWithAddressUseCase _getCurrentLocationWithAddress;
  final GetLocationFromAddressUseCase _getLocationFromAddress;
  final GetLocationFromCoordinatesUseCase _getLocationFromCoordinates;

  Future<void> _onUseCurrentLocationRequested(
    AddEditPlaceUseCurrentLocationRequested event,
    Emitter<AddEditPlaceState> emit,
  ) async {
    emit(state.copyWith(locationLoading: true, locationError: null));
    try {
      final result = await _getCurrentLocationWithAddress.call();
      emit(state.copyWith(
        locationLoading: false,
        locationResult: result,
        locationError: null,
      ));
    } catch (e, _) {
      final message = e.toString().split('\n').first;
      emit(state.copyWith(
        locationLoading: false,
        locationError: message,
      ));
    }
  }

  Future<void> _onAddressSearchRequested(
    AddEditPlaceAddressSearchRequested event,
    Emitter<AddEditPlaceState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) return;
    emit(state.copyWith(locationLoading: true, locationError: null));
    try {
      final result = await _getLocationFromAddress.call(query);
      if (result == null) {
        emit(state.copyWith(
          locationLoading: false,
          locationError: 'Address not found',
        ));
        return;
      }
      emit(state.copyWith(
        locationLoading: false,
        locationResult: result,
        locationError: null,
      ));
    } catch (e, _) {
      final message = e.toString().split('\n').first;
      emit(state.copyWith(
        locationLoading: false,
        locationError: message,
      ));
    }
  }

  Future<void> _onMapLocationSelected(
    AddEditPlaceMapLocationSelected event,
    Emitter<AddEditPlaceState> emit,
  ) async {
    emit(state.copyWith(locationLoading: true, locationError: null));
    try {
      final result = await _getLocationFromCoordinates.call(
        event.latitude,
        event.longitude,
      );
      emit(state.copyWith(
        locationLoading: false,
        locationResult: result,
        locationError: null,
      ));
    } catch (e, _) {
      final message = e.toString().split('\n').first;
      emit(state.copyWith(
        locationLoading: false,
        locationError: message,
      ));
    }
  }
}

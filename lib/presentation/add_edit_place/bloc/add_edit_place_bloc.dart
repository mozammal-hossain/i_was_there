import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/location/use_cases/get_current_location_with_address_use_case.dart';
import 'add_edit_place_event.dart';
import 'add_edit_place_state.dart';

/// BLoC for add/edit place page. Handles "use current location" via use case only (CUSTOM_RULES).
class AddEditPlaceBloc extends Bloc<AddEditPlaceEvent, AddEditPlaceState> {
  AddEditPlaceBloc(this._getCurrentLocationWithAddress)
      : super(const AddEditPlaceState()) {
    on<AddEditPlaceUseCurrentLocationRequested>(_onUseCurrentLocationRequested);
  }

  final GetCurrentLocationWithAddressUseCase _getCurrentLocationWithAddress;

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
}

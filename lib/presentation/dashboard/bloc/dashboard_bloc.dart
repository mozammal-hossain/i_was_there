import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/places/use_cases/add_place_use_case.dart';
import '../../../../domain/places/use_cases/get_places_use_case.dart';
import '../../../../domain/places/use_cases/remove_place_use_case.dart';
import '../../../../domain/places/use_cases/update_place_use_case.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc({
    required GetPlacesUseCase getPlaces,
    required AddPlaceUseCase addPlace,
    required UpdatePlaceUseCase updatePlace,
    required RemovePlaceUseCase removePlace,
  })  : _getPlaces = getPlaces,
        _addPlace = addPlace,
        _updatePlace = updatePlace,
        _removePlace = removePlace,
        super(const DashboardState()) {
    on<DashboardLoadRequested>(_onLoad);
    on<DashboardAddRequested>(_onAdd);
    on<DashboardUpdateRequested>(_onUpdate);
    on<DashboardRemoveRequested>(_onRemove);
  }

  final GetPlacesUseCase _getPlaces;
  final AddPlaceUseCase _addPlace;
  final UpdatePlaceUseCase _updatePlace;
  final RemovePlaceUseCase _removePlace;

  Future<void> _onLoad(
      DashboardLoadRequested event, Emitter<DashboardState> emit) async {
    try {
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onAdd(
      DashboardAddRequested event, Emitter<DashboardState> emit) async {
    try {
      await _addPlace.call(event.place);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(
      DashboardUpdateRequested event, Emitter<DashboardState> emit) async {
    try {
      await _updatePlace.call(event.place);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRemove(
      DashboardRemoveRequested event, Emitter<DashboardState> emit) async {
    try {
      await _removePlace.call(event.id);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

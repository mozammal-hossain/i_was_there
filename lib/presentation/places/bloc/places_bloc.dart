import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/places/use_cases/add_place_use_case.dart';
import '../../../../domain/places/use_cases/get_places_use_case.dart';
import '../../../../domain/places/use_cases/remove_place_use_case.dart';
import '../../../../domain/places/use_cases/update_place_use_case.dart';
import 'places_event.dart';
import 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  PlacesBloc({
    required GetPlacesUseCase getPlaces,
    required AddPlaceUseCase addPlace,
    required UpdatePlaceUseCase updatePlace,
    required RemovePlaceUseCase removePlace,
  })  : _getPlaces = getPlaces,
        _addPlace = addPlace,
        _updatePlace = updatePlace,
        _removePlace = removePlace,
        super(const PlacesState()) {
    on<PlacesLoadRequested>(_onLoad);
    on<PlacesAddRequested>(_onAdd);
    on<PlacesUpdateRequested>(_onUpdate);
    on<PlacesRemoveRequested>(_onRemove);
  }

  final GetPlacesUseCase _getPlaces;
  final AddPlaceUseCase _addPlace;
  final UpdatePlaceUseCase _updatePlace;
  final RemovePlaceUseCase _removePlace;

  Future<void> _onLoad(PlacesLoadRequested event, Emitter<PlacesState> emit) async {
    try {
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onAdd(PlacesAddRequested event, Emitter<PlacesState> emit) async {
    try {
      await _addPlace.call(event.place);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onUpdate(PlacesUpdateRequested event, Emitter<PlacesState> emit) async {
    try {
      await _updatePlace.call(event.place);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRemove(PlacesRemoveRequested event, Emitter<PlacesState> emit) async {
    try {
      await _removePlace.call(event.id);
      final places = await _getPlaces.call();
      emit(state.copyWith(places: places, errorMessage: null));
    } catch (e, _) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}

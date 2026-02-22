import '../../../../domain/places/entities/place.dart';

abstract class PlacesEvent {}

class PlacesLoadRequested extends PlacesEvent {}

class PlacesAddRequested extends PlacesEvent {
  PlacesAddRequested(this.place);
  final Place place;
}

class PlacesUpdateRequested extends PlacesEvent {
  PlacesUpdateRequested(this.place);
  final Place place;
}

class PlacesRemoveRequested extends PlacesEvent {
  PlacesRemoveRequested(this.id);
  final String id;
}

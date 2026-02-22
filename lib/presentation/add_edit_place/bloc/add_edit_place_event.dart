/// Events for the add/edit place page (CUSTOM_RULES: bloc scoped to page).
abstract class AddEditPlaceEvent {
  const AddEditPlaceEvent();
}

/// User requested to use current device location for the place.
class AddEditPlaceUseCurrentLocationRequested extends AddEditPlaceEvent {
  const AddEditPlaceUseCurrentLocationRequested();
}

/// User requested to search for an address and set the place location from the result.
class AddEditPlaceAddressSearchRequested extends AddEditPlaceEvent {
  const AddEditPlaceAddressSearchRequested(this.query);
  final String query;
}

/// User tapped on the map to select a location (lat/lng will be reverse-geocoded to address).
class AddEditPlaceMapLocationSelected extends AddEditPlaceEvent {
  const AddEditPlaceMapLocationSelected(this.latitude, this.longitude);
  final double latitude;
  final double longitude;
}

/// Events for the add/edit place page (CUSTOM_RULES: bloc scoped to page).
abstract class AddEditPlaceEvent {
  const AddEditPlaceEvent();
}

/// User requested to use current device location for the place.
class AddEditPlaceUseCurrentLocationRequested extends AddEditPlaceEvent {
  const AddEditPlaceUseCurrentLocationRequested();
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_form_sheet.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_header.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_map_area.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_my_location_button.dart';
import '../../../domain/places/entities/place.dart';
import '../dashboard/bloc/dashboard_bloc.dart';
import '../dashboard/bloc/dashboard_state.dart';
import 'bloc/add_edit_place_bloc.dart';
import 'bloc/add_edit_place_event.dart';
import 'bloc/add_edit_place_state.dart';

/// Add or edit a tracked place (PRD R2: pin on map, current location, address search; R3: 20m geofence).
/// Location logic in AddEditPlaceBloc via use case (CUSTOM_RULES).
class AddEditPlacePage extends StatefulWidget {
  const AddEditPlacePage({super.key, this.place, required this.onSave});

  /// If null, we are adding; otherwise editing.
  final Place? place;
  final void Function(Place place) onSave;

  @override
  State<AddEditPlacePage> createState() => _AddEditPlacePageState();
}

class _AddEditPlacePageState extends State<AddEditPlacePage> {
  late final TextEditingController _nameController;
  late final TextEditingController _addressController;

  /// Place id we're waiting for after save. When bloc state includes it, we pop.
  String? _pendingSavedPlaceId;

  @override
  void initState() {
    super.initState();
    final p = widget.place;
    _nameController = TextEditingController(text: p?.name ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _save(BuildContext context) {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a place name')),
      );
      return;
    }
    final locBloc = context.read<AddEditPlaceBloc>().state.locationResult;
    final lat = locBloc?.latitude ?? widget.place?.latitude ?? 0.0;
    final lng = locBloc?.longitude ?? widget.place?.longitude ?? 0.0;
    final place =
        widget.place?.copyWith(
          name: name,
          address: address.isNotEmpty ? address : widget.place!.address,
          latitude: lat,
          longitude: lng,
        ) ??
        Place(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: name,
          address: address,
          latitude: lat,
          longitude: lng,
          syncStatus: PlaceSyncStatus.geofenceActive,
        );
    setState(() => _pendingSavedPlaceId = place.id);
    widget.onSave(place);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocListener<AddEditPlaceBloc, AddEditPlaceState>(
      listenWhen: (prev, curr) =>
          prev.locationResult != curr.locationResult ||
          curr.locationError != null,
      listener: (context, state) {
        if (state.locationResult != null && mounted) {
          _addressController.text =
              state.locationResult!.address ?? _addressController.text;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location set.')),
          );
        }
        if (state.locationError != null && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not get location: ${state.locationError}'),
            ),
          );
        }
      },
      child: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (prev, curr) =>
            _pendingSavedPlaceId != null &&
            (curr.places.any((p) => p.id == _pendingSavedPlaceId) ||
                curr.errorMessage != null),
        listener: (context, state) {
          if (_pendingSavedPlaceId == null) return;
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Could not save: ${state.errorMessage}'),
                backgroundColor: Colors.red,
              ),
            );
            setState(() => _pendingSavedPlaceId = null);
            return;
          }
          if (state.places.any((p) => p.id == _pendingSavedPlaceId)) {
            setState(() => _pendingSavedPlaceId = null);
            if (mounted) context.pop();
          }
        },
        child: Scaffold(
          body: Column(
            children: [
              AddEditPlaceHeader(isDark: isDark),
              Expanded(
                child: Stack(
                  children: [
                    BlocBuilder<AddEditPlaceBloc, AddEditPlaceState>(
                      buildWhen: (prev, curr) =>
                          prev.locationResult != curr.locationResult,
                      builder: (context, state) {
                        final loc = state.locationResult;
                        final p = widget.place;
                        final hasLoc = loc != null;
                        final hasPlace = p != null &&
                            (p.latitude != 0 || p.longitude != 0);
                        final LatLng? center = hasLoc
                            ? LatLng(loc.latitude, loc.longitude)
                            : (hasPlace
                                ? LatLng(p.latitude, p.longitude)
                                : null);
                        return AddEditPlaceMapArea(
                          isDark: isDark,
                          center: center,
                          onMapTap: (point) =>
                              context.read<AddEditPlaceBloc>().add(
                                    AddEditPlaceMapLocationSelected(
                                      point.latitude,
                                      point.longitude,
                                    ),
                                  ),
                        );
                      },
                    ),
                    BlocBuilder<AddEditPlaceBloc, AddEditPlaceState>(
                      buildWhen: (prev, curr) =>
                          prev.locationLoading != curr.locationLoading,
                      builder: (context, state) {
                        return AddEditPlaceMyLocationButton(
                          isLoading: state.locationLoading,
                          onTap: () => context.read<AddEditPlaceBloc>().add(
                            const AddEditPlaceUseCurrentLocationRequested(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              BlocBuilder<AddEditPlaceBloc, AddEditPlaceState>(
                buildWhen: (prev, curr) =>
                    prev.locationLoading != curr.locationLoading,
                builder: (context, state) {
                  return AddEditPlaceFormSheet(
                    isDark: isDark,
                    nameController: _nameController,
                    addressController: _addressController,
                    locationLoading: state.locationLoading,
                    onUseCurrentLocation: () => context
                        .read<AddEditPlaceBloc>()
                        .add(const AddEditPlaceUseCurrentLocationRequested()),
                    onSearchAddress: () => context.read<AddEditPlaceBloc>().add(
                          AddEditPlaceAddressSearchRequested(
                            _addressController.text,
                          ),
                        ),
                    onSave: () => _save(context),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

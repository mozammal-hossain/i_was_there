import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_bloc.dart';
import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_event.dart';
import 'package:i_was_there/presentation/add_edit_place/bloc/add_edit_place_state.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_map_area.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_my_location_button.dart';

/// Map and "my location" button for add/edit place. Reads [AddEditPlaceBloc] from context.
class AddEditPlaceMapSection extends StatelessWidget {
  const AddEditPlaceMapSection({
    super.key,
    required this.isDark,
    this.place,
  });

  final bool isDark;
  final Place? place;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<AddEditPlaceBloc, AddEditPlaceState>(
          buildWhen: (prev, curr) => prev.locationResult != curr.locationResult,
          builder: (context, state) {
            final loc = state.locationResult;
            final p = place;
            final hasLoc = loc != null;
            final hasPlace =
                p != null && (p.latitude != 0 || p.longitude != 0);
            final LatLng? center = hasLoc
                ? LatLng(loc.latitude, loc.longitude)
                : (hasPlace ? LatLng(p.latitude, p.longitude) : null);
            return AddEditPlaceMapArea(
              isDark: isDark,
              center: center,
              onMapTap: (point) => context.read<AddEditPlaceBloc>().add(
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
    );
  }
}

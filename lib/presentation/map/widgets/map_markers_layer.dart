import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';

/// Builds map markers from places. Widget class per CUSTOM_RULES (no _build* methods).
class MapMarkersLayer extends StatelessWidget {
  const MapMarkersLayer({super.key, required this.places});

  final List<Place> places;

  static List<Marker> createMarkers(BuildContext context, List<Place> places) {
    final primary = Theme.of(context).colorScheme.primary;
    final List<Marker> m = [];
    for (final place in places) {
      if (place.latitude != 0 || place.longitude != 0) {
        m.add(
          Marker(
            point: LatLng(place.latitude, place.longitude),
            width: AppSize.avatarSm,
            height: AppSize.avatarSm,
            child: Icon(
              Icons.place,
              color: primary,
              size: AppSize.avatarSm,
            ),
          ),
        );
      }
    }
    return m;
  }

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(markers: createMarkers(context, places));
  }
}

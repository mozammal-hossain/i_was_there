import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

/// Map area for add/edit place: shows OSM map and optional pin at [center].
/// When [center] is null, shows default view; when set, centers and shows a marker.
/// [onMapTap] is called when the user taps on the map with the tapped coordinates.
class AddEditPlaceMapArea extends StatefulWidget {
  const AddEditPlaceMapArea({
    super.key,
    required this.isDark,
    this.center,
    this.onMapTap,
  });

  final bool isDark;
  /// Current place location (from address search or "use my location"). When null, default center is used and no marker is shown.
  final LatLng? center;
  /// Called when the user taps on the map with the tapped point (lat/lng).
  final void Function(LatLng point)? onMapTap;

  static const double _defaultLat = 34.0195;
  static const double _defaultLng = -118.4912;
  static const double _defaultZoom = 12.0;
  static const double _placeZoom = 15.0;

  @override
  State<AddEditPlaceMapArea> createState() => _AddEditPlaceMapAreaState();
}

class _AddEditPlaceMapAreaState extends State<AddEditPlaceMapArea> {
  final MapController _mapController = MapController();

  LatLng get _initialCenter =>
      widget.center ?? const LatLng(AddEditPlaceMapArea._defaultLat, AddEditPlaceMapArea._defaultLng);

  @override
  void didUpdateWidget(AddEditPlaceMapArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.center != widget.center && widget.center != null) {
      _mapController.move(widget.center!, AddEditPlaceMapArea._placeZoom);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _initialCenter,
          initialZoom: widget.center != null
              ? AddEditPlaceMapArea._placeZoom
              : AddEditPlaceMapArea._defaultZoom,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all,
          ),
          onTap: (_, point) => widget.onMapTap?.call(point),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'i_was_there',
          ),
          if (widget.center != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: widget.center!,
                  width: AppSize.avatarSm,
                  height: AppSize.avatarSm,
                  child: Icon(
                    Icons.place,
                    color: AppColors.primary,
                    size: AppSize.avatarSm,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

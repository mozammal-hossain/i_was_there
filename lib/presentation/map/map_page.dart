import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';
import 'package:i_was_there/domain/places/entities/place.dart';
import 'package:i_was_there/presentation/map/widgets/map_markers_layer.dart';

/// Map tab: shows tracked places as pins (PRD map in dashboard nav).
/// Uses OpenStreetMap via flutter_map — no API key required.
class MapPage extends StatefulWidget {
  const MapPage({super.key, this.places = const [], this.onBack});

  final List<Place> places;
  final VoidCallback? onBack;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  static const double _defaultLat = 34.0195;
  static const double _defaultLng = -118.4912;
  static const double _defaultZoom = 12.0;

  void _onMapReady() {
    final markers = MapMarkersLayer.createMarkers(context, widget.places);
    if (markers.isNotEmpty) _fitBounds(markers);
  }

  void _fitBounds(List<Marker> markers) {
    if (markers.isEmpty) return;
    final points = markers.map((m) => m.point).toList();
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(AppSize.mapPadding),
      ),
    );
  }

  LatLng get _initialCenter {
    final withCoords = widget.places
        .where((p) => p.latitude != 0 || p.longitude != 0)
        .toList();
    if (withCoords.isEmpty) {
      return const LatLng(_defaultLat, _defaultLng);
    }
    double lat = 0, lng = 0;
    for (final p in withCoords) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / withCoords.length, lng / withCoords.length);
  }

  @override
  void didUpdateWidget(MapPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.places != widget.places) {
      final markers = MapMarkersLayer.createMarkers(context, widget.places);
      if (markers.isNotEmpty) _fitBounds(markers);
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter,
              initialZoom: widget.places.isEmpty ? _defaultZoom : 10.0,
              onMapReady: _onMapReady,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'i_was_there',
              ),
              MapMarkersLayer(places: widget.places),
            ],
          ),
          if (widget.onBack != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + AppSize.spacingM,
              left: AppSize.spacingL,
              child: Material(
                elevation: AppSize.spacingXs,
                borderRadius: BorderRadius.circular(AppSize.radiusL),
                child: InkWell(
                  onTap: widget.onBack,
                  borderRadius: BorderRadius.circular(AppSize.radiusL),
                  child: Container(
                    padding: const EdgeInsets.all(AppSize.spacingM2),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.bgDarkGray : Colors.white)
                          .withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(AppSize.radiusL),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: AppSize.iconL3,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.places.isEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.all(AppSize.spacingXl),
                padding: const EdgeInsets.all(AppSize.spacingXl),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.bgDarkGray : Colors.white)
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(AppSize.radiusXl2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: AppSize.spacingL,
                      offset: const Offset(0, AppSize.spacingM),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: AppSize.iconXl2,
                      color: (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: AppSize.spacingL),
                    Text(
                      AppLocalizations.of(context)!.noPlacesToShow,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: AppSize.spacingM),
                    Text(
                      AppLocalizations.of(context)!.addTrackedPlacesFromDashboard,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

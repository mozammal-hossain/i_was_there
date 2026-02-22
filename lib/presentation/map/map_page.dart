import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/places/entities/place.dart';

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
    final markers = _MapMarkersLayer.createMarkers(context, widget.places);
    if (markers.isNotEmpty) _fitBounds(markers);
  }

  void _fitBounds(List<Marker> markers) {
    if (markers.isEmpty) return;
    final points = markers.map((m) => m.point).toList();
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(80)),
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
      final markers = _MapMarkersLayer.createMarkers(context, widget.places);
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
              _MapMarkersLayer(places: widget.places),
            ],
          ),
          if (widget.onBack != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 16,
              child: Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: widget.onBack,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isDark ? AppColors.bgDarkGray : Colors.white)
                          .withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.chevron_left,
                      size: 28,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          if (widget.places.isEmpty)
            Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.bgDarkGray : Colors.white)
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.place_outlined,
                      size: 48,
                      color: (isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No places to show',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add tracked places from the dashboard to see them on the map.',
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

/// Builds map markers from places. Widget class per CUSTOM_RULES (no _build* methods).
class _MapMarkersLayer extends StatelessWidget {
  const _MapMarkersLayer({required this.places});

  final List<Place> places;

  static List<Marker> createMarkers(BuildContext context, List<Place> places) {
    final primary = Theme.of(context).colorScheme.primary;
    final List<Marker> m = [];
    for (final place in places) {
      if (place.latitude != 0 || place.longitude != 0) {
        m.add(
          Marker(
            point: LatLng(place.latitude, place.longitude),
            width: 40,
            height: 40,
            child: Icon(Icons.place, color: primary, size: 40),
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

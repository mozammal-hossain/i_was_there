import 'dart:math' as math;

/// Earth radius in meters (approximate).
const double earthRadiusMeters = 6_371_000;

/// Haversine distance between two (lat, lng) points in meters (PRD R3: 20 m geofence).
double haversineMeters(double lat1, double lon1, double lat2, double lon2) {
  final dLat = _toRad(lat2 - lat1);
  final dLon = _toRad(lon2 - lon1);
  final a =
      math.sin(dLat / 2) * math.sin(dLat / 2) +
      math.cos(_toRad(lat1)) *
          math.cos(_toRad(lat2)) *
          math.sin(dLon / 2) *
          math.sin(dLon / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return earthRadiusMeters * c;
}

double _toRad(double deg) => deg * (math.pi / 180);

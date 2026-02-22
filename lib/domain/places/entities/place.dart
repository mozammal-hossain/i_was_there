/// A tracked place (PRD R1–R4): name, location, 20m geofence.
class Place {
  const Place({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.syncStatus = PlaceSyncStatus.none,
    this.weeklyPresence = const [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;

  /// e.g. "Synced to Calendar", "Geofence Active", "Auto-sync Enabled"
  final PlaceSyncStatus syncStatus;

  /// [Mon, Tue, Wed, Thu, Fri, Sat, Sun] – present or not (PRD R7).
  final List<bool> weeklyPresence;

  Place copyWith({
    String? id,
    String? name,
    String? address,
    double? latitude,
    double? longitude,
    PlaceSyncStatus? syncStatus,
    List<bool>? weeklyPresence,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      syncStatus: syncStatus ?? this.syncStatus,
      weeklyPresence: weeklyPresence ?? List<bool>.from(this.weeklyPresence),
    );
  }
}

enum PlaceSyncStatus { none, syncedToCalendar, geofenceActive, autoSyncEnabled }

extension PlaceSyncStatusX on PlaceSyncStatus {
  String get label {
    switch (this) {
      case PlaceSyncStatus.syncedToCalendar:
        return 'Synced to Calendar';
      case PlaceSyncStatus.geofenceActive:
        return 'Geofence Active';
      case PlaceSyncStatus.autoSyncEnabled:
        return 'Auto-sync Enabled';
      case PlaceSyncStatus.none:
        return 'Not synced';
    }
  }
}

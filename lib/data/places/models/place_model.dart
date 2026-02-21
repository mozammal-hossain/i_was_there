/// Data-layer model for Place. Mapped to/from domain entity via PlaceMapper.
class PlaceModel {
  const PlaceModel({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.syncStatusIndex = 0,
    this.weeklyPresence = const [false, false, false, false, false, false, false],
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int syncStatusIndex;
  final List<bool> weeklyPresence;
}

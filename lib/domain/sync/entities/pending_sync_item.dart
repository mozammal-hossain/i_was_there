class PendingSyncItem {
  const PendingSyncItem({
    required this.placeId,
    required this.placeName,
    required this.date,
    this.firstDetectedAt,
  });

  final String placeId;
  final String placeName;
  final DateTime date;
  final DateTime? firstDetectedAt;
}

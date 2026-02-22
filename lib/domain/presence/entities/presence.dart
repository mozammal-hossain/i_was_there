/// Presence for a place on a calendar day (PRD R6, R7).
class Presence {
  const Presence({
    required this.placeId,
    required this.date,
    required this.isPresent,
    required this.source,
    this.firstDetectedAt,
  });

  final String placeId;
  final DateTime date;
  final bool isPresent;
  final PresenceSource source;
  final DateTime? firstDetectedAt;
}

enum PresenceSource { auto, manual }

/// Result of a force-update check.
class ForceUpdateResult {
  const ForceUpdateResult({
    required this.forceUpdateRequired,
    required this.recommendedUpdateAvailable,
  });

  /// User must update before using the app (blocking screen).
  final bool forceUpdateRequired;

  /// Newer version available; optional skippable dialog can be shown.
  final bool recommendedUpdateAvailable;
}

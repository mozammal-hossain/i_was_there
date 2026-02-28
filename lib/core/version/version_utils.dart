/// Parses a semver-style version string (e.g. "1.2.3" or "1.2.3+4")
/// and returns a comparable integer for ordering.
///
/// Format: major.minor.patch with optional +build (build is ignored).
/// Missing segments are treated as 0.
int parseVersionNumber(String version) {
  final normalized = version.split('+').first.trim();
  final parts = normalized.split('.').map((s) => int.tryParse(s.trim()) ?? 0).toList();
  final major = parts.isNotEmpty ? parts[0] : 0;
  final minor = parts.length > 1 ? parts[1] : 0;
  final patch = parts.length > 2 ? parts[2] : 0;
  return major * 100000 + minor * 1000 + patch;
}

/// Returns true if [current] is strictly less than [minimum]
/// (so an update is required to reach [minimum]).
bool isVersionLessThan(String current, String minimum) {
  return parseVersionNumber(current) < parseVersionNumber(minimum);
}

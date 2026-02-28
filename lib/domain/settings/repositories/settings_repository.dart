/// Domain interface for app settings (e.g. calendar sync on/off). Implemented in data layer.
abstract class SettingsRepository {
  Future<bool> getCalendarSyncEnabled();
  Future<void> setCalendarSyncEnabled(bool enabled);

  /// Stored locale language code (e.g. [en], [bn]). Returns null if not set (use app default).
  Future<String?> getLocaleLanguageCode();

  Future<void> setLocaleLanguageCode(String languageCode);

  /// Last calendar sync time. Returns null if never synced.
  Future<DateTime?> getLastSyncTime();

  Future<void> setLastSyncTime(DateTime time);
}

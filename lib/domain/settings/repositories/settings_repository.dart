/// Domain interface for app settings (e.g. calendar sync on/off). Implemented in data layer.
abstract class SettingsRepository {
  Future<bool> getCalendarSyncEnabled();
  Future<void> setCalendarSyncEnabled(bool enabled);
}

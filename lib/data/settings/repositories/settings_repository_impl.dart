import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/settings/repositories/settings_repository.dart';
import '../../database/app_database.dart';

const _keyCalendarSyncEnabled = 'calendar_sync_enabled';
const _keyLocale = 'locale';
const _keyLastSyncTime = 'last_sync_time';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<bool> getCalendarSyncEnabled() async {
    final row = await (_db.select(
      _db.settings,
    )..where((t) => t.key.equals(_keyCalendarSyncEnabled))).getSingleOrNull();
    return row?.value == 'true';
  }

  @override
  Future<void> setCalendarSyncEnabled(bool enabled) async {
    await _db
        .into(_db.settings)
        .insert(
          SettingsCompanion.insert(
            key: _keyCalendarSyncEnabled,
            value: enabled ? 'true' : 'false',
          ),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<String?> getLocaleLanguageCode() async {
    final row = await (_db.select(_db.settings)
          ..where((t) => t.key.equals(_keyLocale)))
        .getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> setLocaleLanguageCode(String languageCode) async {
    await _db.into(_db.settings).insert(
          SettingsCompanion.insert(key: _keyLocale, value: languageCode),
          mode: InsertMode.insertOrReplace,
        );
  }

  @override
  Future<DateTime?> getLastSyncTime() async {
    final row = await (_db.select(_db.settings)
            ..where((t) => t.key.equals(_keyLastSyncTime)))
        .getSingleOrNull();
    if (row?.value == null) return null;
    return DateTime.tryParse(row!.value);
  }

  @override
  Future<void> setLastSyncTime(DateTime time) async {
    await _db.into(_db.settings).insert(
          SettingsCompanion.insert(
            key: _keyLastSyncTime,
            value: time.toUtc().toIso8601String(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  }
}

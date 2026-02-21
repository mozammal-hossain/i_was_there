import 'package:drift/drift.dart';

import '../../../../domain/settings/repositories/settings_repository.dart';
import '../../database/app_database.dart';

const _keyCalendarSyncEnabled = 'calendar_sync_enabled';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<bool> getCalendarSyncEnabled() async {
    final row = await (_db.select(_db.settings)..where((t) => t.key.equals(_keyCalendarSyncEnabled))).getSingleOrNull();
    return row?.value == 'true';
  }

  @override
  Future<void> setCalendarSyncEnabled(bool enabled) async {
    await _db.into(_db.settings).insert(
          SettingsCompanion.insert(key: _keyCalendarSyncEnabled, value: enabled ? 'true' : 'false'),
          mode: InsertMode.insertOrReplace,
        );
  }
}

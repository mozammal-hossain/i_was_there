import 'package:flutter/material.dart';

import '../../data/database/app_database.dart' show AppDatabase;
import '../../data/settings/repositories/settings_repository_impl.dart';
import 'widgets/settings_screen.dart';

/// Settings feature: Calendar Sync and app settings.
class SettingsFeature extends StatelessWidget {
  SettingsFeature({super.key, AppDatabase? database})
      : _database = database ?? AppDatabase();

  final AppDatabase _database;

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      settingsRepository: SettingsRepositoryImpl(_database),
    );
  }
}

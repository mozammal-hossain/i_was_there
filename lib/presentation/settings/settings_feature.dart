import 'package:flutter/material.dart';

import '../../core/di/injection.dart';
import '../../domain/settings/repositories/settings_repository.dart';
import 'widgets/settings_screen.dart';

/// Settings feature: Calendar Sync and app settings.
class SettingsFeature extends StatelessWidget {
  const SettingsFeature({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsScreen(
      settingsRepository: getIt<SettingsRepository>(),
    );
  }
}

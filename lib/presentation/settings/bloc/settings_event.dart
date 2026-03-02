abstract class SettingsEvent {}

class SettingsLoadRequested extends SettingsEvent {}

class SettingsSyncEnabledChanged extends SettingsEvent {
  SettingsSyncEnabledChanged(this.enabled);
  final bool enabled;
}

class SettingsGoogleSignInRequested extends SettingsEvent {}

class SettingsGoogleSignOutRequested extends SettingsEvent {}

class SettingsSyncNowRequested extends SettingsEvent {}

class SettingsAccountLoadRequested extends SettingsEvent {}

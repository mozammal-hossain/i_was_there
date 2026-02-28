abstract class SettingsEvent {}

class SettingsLoadRequested extends SettingsEvent {}

class SettingsSyncEnabledChanged extends SettingsEvent {
  SettingsSyncEnabledChanged(this.enabled);
  final bool enabled;
}

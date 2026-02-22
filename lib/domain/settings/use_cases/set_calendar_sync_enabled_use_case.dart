import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class SetCalendarSyncEnabledUseCase {
  SetCalendarSyncEnabledUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(bool enabled) =>
      _repository.setCalendarSyncEnabled(enabled);
}

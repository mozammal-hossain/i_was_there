import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class GetCalendarSyncEnabledUseCase {
  GetCalendarSyncEnabledUseCase(this._repository);

  final SettingsRepository _repository;

  Future<bool> call() => _repository.getCalendarSyncEnabled();
}

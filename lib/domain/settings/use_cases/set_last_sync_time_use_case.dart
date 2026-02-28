import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class SetLastSyncTimeUseCase {
  SetLastSyncTimeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(DateTime time) => _repository.setLastSyncTime(time);
}

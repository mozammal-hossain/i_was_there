import 'package:injectable/injectable.dart';

import '../repositories/settings_repository.dart';

@injectable
class GetLastSyncTimeUseCase {
  GetLastSyncTimeUseCase(this._repository);

  final SettingsRepository _repository;

  Future<DateTime?> call() => _repository.getLastSyncTime();
}

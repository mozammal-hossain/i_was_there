import 'package:injectable/injectable.dart';

import '../entities/google_account_info.dart';
import '../google_auth_service.dart';

@injectable
class GetGoogleAccountUseCase {
  GetGoogleAccountUseCase(this._googleAuthService);

  final GoogleAuthService _googleAuthService;

  Future<GoogleAccountInfo?> call() async {
    return _googleAuthService.getCurrentAccount();
  }
}

import 'package:injectable/injectable.dart';

import '../google_auth_service.dart';

@injectable
class SignOutGoogleUseCase {
  SignOutGoogleUseCase(this._googleAuthService);

  final GoogleAuthService _googleAuthService;

  Future<void> call() async {
    await _googleAuthService.signOut();
  }
}

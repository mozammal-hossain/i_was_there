sealed class SettingsFailure {
  const SettingsFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

class GeneralFailure extends SettingsFailure {
  const GeneralFailure(super.message);
}

class SignInFailure extends SettingsFailure {
  const SignInFailure(super.message);
}

class SyncFailure extends SettingsFailure {
  const SyncFailure(super.message);
}

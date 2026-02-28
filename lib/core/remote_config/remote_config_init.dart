import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Initializes Firebase Remote Config with defaults and fetches latest values.
/// Call after [Firebase.initializeApp()] in main.
Future<void> initializeRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  await remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );
  await remoteConfig.setDefaults(const {
    'requiredMinimumVersion': '1.0.0',
    'recommendedMinimumVersion': '1.0.0',
  });
  await remoteConfig.fetchAndActivate();
  remoteConfig.onConfigUpdated.listen((_) async {
    await remoteConfig.activate();
  });
}

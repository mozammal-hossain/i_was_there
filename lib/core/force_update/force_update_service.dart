import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:injectable/injectable.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../version/version_utils.dart';
import 'force_update_result.dart';

@lazySingleton
class ForceUpdateService {
  Future<ForceUpdateResult> checkUpdateRequired() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    final requiredMin = remoteConfig.getString('requiredMinimumVersion');
    final recommendedMin = remoteConfig.getString('recommendedMinimumVersion');
    final packageInfo = await PackageInfo.fromPlatform();
    final current = packageInfo.version;

    final forceRequired = isVersionLessThan(current, requiredMin);
    final recommendedAvailable =
        !forceRequired && isVersionLessThan(current, recommendedMin);

    return ForceUpdateResult(
      forceUpdateRequired: forceRequired,
      recommendedUpdateAvailable: recommendedAvailable,
    );
  }

  /// Returns the store URL from Remote Config (e.g. Play Store listing).
  String getStoreUrl() {
    final remoteConfig = FirebaseRemoteConfig.instance;
    return remoteConfig.getString('androidStoreUrl');
  }
}

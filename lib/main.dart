import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/background/background_task.dart';
import 'core/di/injection.dart';
import 'core/force_update/force_update_service.dart';
import 'core/remote_config/remote_config_init.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeRemoteConfig();
  configureDependencies();
  final forceUpdateResult = await getIt<ForceUpdateService>().checkUpdateRequired();
  final updateRequiredNotifier = ValueNotifier<bool>(forceUpdateResult.forceUpdateRequired);
  await registerBackgroundTask();
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleteNotifier = ValueNotifier<bool>(
    await isOnboardingCompleted(prefs),
  );
  final router = createAppRouter(
    prefs: prefs,
    onboardingCompleteNotifier: onboardingCompleteNotifier,
    updateRequiredNotifier: updateRequiredNotifier,
  );
  runApp(MyApp(router: router));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'I Was There',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(isDark: false),
      darkTheme: buildAppTheme(isDark: true),
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

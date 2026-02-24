import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/background/background_task.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'main.dart' as app;

/// Entry point for integration tests. Marks onboarding as completed so tests
/// start at the main shell (Places / Calendar / Settings) instead of onboarding.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  await registerBackgroundTask();
  final prefs = await SharedPreferences.getInstance();
  await setOnboardingCompleted(prefs);
  final onboardingCompleteNotifier = ValueNotifier<bool>(true);
  final updateRequiredNotifier = ValueNotifier<bool>(false);
  final router = createAppRouter(
    prefs: prefs,
    onboardingCompleteNotifier: onboardingCompleteNotifier,
    updateRequiredNotifier: updateRequiredNotifier,
  );
  runApp(app.MyApp(router: router));
}

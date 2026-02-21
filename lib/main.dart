import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/background/background_task.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await registerBackgroundTask();
  final database = AppDatabase();
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleteNotifier = ValueNotifier<bool>(
    await isOnboardingCompleted(prefs),
  );
  final router = createAppRouter(
    prefs: prefs,
    database: database,
    onboardingCompleteNotifier: onboardingCompleteNotifier,
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

import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/background/background_task.dart';
import 'core/di/injection.dart';
import 'core/error/app_error_handler.dart';
import 'core/force_update/force_update_service.dart';
import 'core/locale/app_locale_service.dart';
import 'core/remote_config/remote_config_init.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  setupGlobalErrorHandling(scaffoldMessengerKey);

  await runZonedGuarded<Future<void>>(
    () async {
      // ensureInitialized must run in the same zone as runApp
      WidgetsFlutterBinding.ensureInitialized();

      await Firebase.initializeApp();
      await initializeRemoteConfig();
      configureDependencies();
      final localeService = getIt<AppLocaleService>();
      await localeService.init();
      final forceUpdateResult = await getIt<ForceUpdateService>()
          .checkUpdateRequired();
      final updateRequiredNotifier = ValueNotifier<bool>(
        forceUpdateResult.forceUpdateRequired,
      );
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
      runApp(
        MyApp(
          router: router,
          scaffoldMessengerKey: scaffoldMessengerKey,
          localeNotifier: localeService.localeNotifier,
        ),
      );
    },
    (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'runZonedGuarded',
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
    required this.router,
    this.scaffoldMessengerKey,
    required this.localeNotifier,
  });

  final GoRouter router;
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;
  final ValueNotifier<Locale> localeNotifier;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        final title = lookupAppLocalizations(locale).appTitle;
        return MaterialApp.router(
          title: title,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: buildAppTheme(isDark: false),
          darkTheme: buildAppTheme(isDark: true),
          themeMode: ThemeMode.system,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: locale,
          routerConfig: router,
        );
      },
    );
  }
}

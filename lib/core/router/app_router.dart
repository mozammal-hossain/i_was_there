import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/main_shell.dart';
import '../../presentation/onboarding/onboarding_feature.dart';

const String _keyOnboardingCompleted = 'onboarding_completed';

/// Returns whether onboarding has been completed (persisted).
Future<bool> isOnboardingCompleted(SharedPreferences prefs) async {
  return prefs.getBool(_keyOnboardingCompleted) ?? false;
}

/// Marks onboarding as completed (persisted).
Future<void> setOnboardingCompleted(SharedPreferences prefs) async {
  await prefs.setBool(_keyOnboardingCompleted, true);
}

/// App router: /onboarding (flow) and / (main shell with Places | Calendar | Settings).
GoRouter createAppRouter({
  required SharedPreferences prefs,
  required ValueNotifier<bool> onboardingCompleteNotifier,
}) {
  return GoRouter(
    refreshListenable: Listenable.merge([onboardingCompleteNotifier]),
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) {
      final completed = onboardingCompleteNotifier.value;
      final onOnboarding = state.matchedLocation == '/onboarding';
      if (!completed && !onOnboarding) {
        return '/onboarding';
      }
      if (completed && onOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingFeature(
          onComplete: () async {
            await setOnboardingCompleted(prefs);
            onboardingCompleteNotifier.value = true;
            if (context.mounted) {
              context.go('/');
            }
          },
        ),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainShell(),
      ),
    ],
  );
}

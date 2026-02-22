import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injection.dart';
import '../../domain/location/use_cases/get_current_location_with_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_coordinates_use_case.dart';
import '../../presentation/main_shell.dart';
import '../../presentation/onboarding_feature.dart';
import '../../presentation/dashboard/bloc/dashboard_bloc.dart';
import '../../presentation/dashboard/bloc/dashboard_event.dart';
import '../../presentation/add_edit_place/add_edit_place_page.dart';
import '../../presentation/add_edit_place/bloc/add_edit_place_bloc.dart';

const String _keyOnboardingCompleted = 'onboarding_completed';

/// Returns whether onboarding has been completed (persisted).
Future<bool> isOnboardingCompleted(SharedPreferences prefs) async {
  return prefs.getBool(_keyOnboardingCompleted) ?? false;
}

/// Marks onboarding as completed (persisted).
Future<void> setOnboardingCompleted(SharedPreferences prefs) async {
  await prefs.setBool(_keyOnboardingCompleted, true);
}

/// Extra data passed when pushing add/edit place routes.
class AddEditPlaceExtra {
  const AddEditPlaceExtra({required this.dashboardBloc, this.place});

  final DashboardBloc dashboardBloc;
  final dynamic place; // Place?
}

/// App router: /onboarding (flow), / (main shell), /places/add, /places/edit/:id.
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
      GoRoute(path: '/', builder: (context, state) => const MainShell()),
      GoRoute(
        path: '/places/add',
        builder: (context, state) {
          final extra = state.extra as AddEditPlaceExtra?;
          if (extra == null) return const SizedBox.shrink();
          return BlocProvider.value(
            value: extra.dashboardBloc,
            child: BlocProvider(
              create: (_) => AddEditPlaceBloc(
                getIt<GetCurrentLocationWithAddressUseCase>(),
                getIt<GetLocationFromAddressUseCase>(),
                getIt<GetLocationFromCoordinatesUseCase>(),
              ),
              child: AddEditPlacePage(
                onSave: (place) =>
                    extra.dashboardBloc.add(DashboardAddRequested(place)),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: '/places/edit/:id',
        builder: (context, state) {
          final extra = state.extra as AddEditPlaceExtra?;
          if (extra == null || extra.place == null) return const SizedBox.shrink();
          return BlocProvider.value(
            value: extra.dashboardBloc,
            child: BlocProvider(
              create: (_) => AddEditPlaceBloc(
                getIt<GetCurrentLocationWithAddressUseCase>(),
                getIt<GetLocationFromAddressUseCase>(),
                getIt<GetLocationFromCoordinatesUseCase>(),
              ),
              child: AddEditPlacePage(
                place: extra.place,
                onSave: (place) =>
                    extra.dashboardBloc.add(DashboardUpdateRequested(place)),
              ),
            ),
          );
        },
      ),
    ],
  );
}

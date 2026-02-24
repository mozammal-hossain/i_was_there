import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../di/injection.dart';
import 'app_routes.dart';
import 'route_args.dart';
import '../../domain/location/use_cases/get_current_location_with_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_address_use_case.dart';
import '../../domain/location/use_cases/get_location_from_coordinates_use_case.dart';
import '../../presentation/force_update/force_update_page.dart';
import '../../presentation/main_shell.dart';
import '../../presentation/onboarding_feature.dart';
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

/// App router: force-update, onboarding (flow), root (main shell), place add/edit.
GoRouter createAppRouter({
  required SharedPreferences prefs,
  required ValueNotifier<bool> onboardingCompleteNotifier,
  required ValueNotifier<bool> updateRequiredNotifier,
}) {
  return GoRouter(
    refreshListenable: Listenable.merge([onboardingCompleteNotifier, updateRequiredNotifier]),
    initialLocation: AppRoutes.root,
    redirect: (BuildContext context, GoRouterState state) {
      if (updateRequiredNotifier.value) {
        return AppRoutes.forceUpdate;
      }
      final completed = onboardingCompleteNotifier.value;
      final onOnboarding = state.matchedLocation == AppRoutes.onboarding;
      if (!completed && !onOnboarding) {
        return AppRoutes.onboarding;
      }
      if (completed && onOnboarding) {
        return AppRoutes.root;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.forceUpdate,
        builder: (context, state) => const ForceUpdatePage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => OnboardingFeature(
          onComplete: () async {
            await setOnboardingCompleted(prefs);
            onboardingCompleteNotifier.value = true;
            if (context.mounted) {
              context.go(AppRoutes.root);
            }
          },
        ),
      ),
      GoRoute(path: AppRoutes.root, builder: (context, state) => const MainShell()),
      GoRoute(
        path: AppRoutes.placeAdd,
        builder: (context, state) {
          final args = state.extra as AddEditPlaceRouteArgs?;
          if (args == null) return const SizedBox.shrink();
          return BlocProvider.value(
            value: args.dashboardBloc,
            child: BlocProvider(
              create: (_) => AddEditPlaceBloc(
                getIt<GetCurrentLocationWithAddressUseCase>(),
                getIt<GetLocationFromAddressUseCase>(),
                getIt<GetLocationFromCoordinatesUseCase>(),
              ),
              child: AddEditPlacePage(
                onSave: (place) =>
                    args.dashboardBloc.add(DashboardAddRequested(place)),
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.placeEditPath,
        builder: (context, state) {
          final args = state.extra as AddEditPlaceRouteArgs?;
          if (args == null || args.place == null) return const SizedBox.shrink();
          return BlocProvider.value(
            value: args.dashboardBloc,
            child: BlocProvider(
              create: (_) => AddEditPlaceBloc(
                getIt<GetCurrentLocationWithAddressUseCase>(),
                getIt<GetLocationFromAddressUseCase>(),
                getIt<GetLocationFromCoordinatesUseCase>(),
              ),
              child: AddEditPlacePage(
                place: args.place,
                onSave: (place) =>
                    args.dashboardBloc.add(DashboardUpdateRequested(place)),
              ),
            ),
          );
        },
      ),
    ],
  );
}

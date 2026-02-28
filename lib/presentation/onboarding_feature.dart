import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/di/injection.dart';
import '../domain/settings/use_cases/get_calendar_sync_enabled_use_case.dart';
import '../domain/settings/use_cases/set_calendar_sync_enabled_use_case.dart';
import 'onboarding/bloc/onboarding_bloc.dart';
import 'onboarding/bloc/onboarding_event.dart';
import 'onboarding/bloc/onboarding_state.dart';
import 'onboarding/onboarding_page.dart';

/// Onboarding flow: Screen 1 (Why) and Screen 2 (How). Calls [onComplete] when user finishes.
class OnboardingFeature extends StatelessWidget {
  const OnboardingFeature({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(
        getCalendarSyncEnabled: getIt<GetCalendarSyncEnabledUseCase>(),
        setCalendarSyncEnabled: getIt<SetCalendarSyncEnabledUseCase>(),
      )..add(OnboardingStarted()),
      child: BlocListener<OnboardingBloc, OnboardingState>(
        listenWhen: (prev, curr) => curr.completeRequested && !prev.completeRequested,
        listener: (context, state) => onComplete(),
        child: const OnboardingPage(),
      ),
    );
  }
}

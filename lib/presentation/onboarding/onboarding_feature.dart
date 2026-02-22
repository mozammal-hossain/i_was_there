import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/onboarding_bloc.dart';
import 'bloc/onboarding_event.dart';
import 'bloc/onboarding_state.dart';
import 'widgets/background_location_screen.dart';
import 'widgets/onboarding_completion_screen.dart';

/// Onboarding flow: foreground/background location permission → completion.
/// Calls [onComplete] when the user finishes (Get Started or Add First Place).
class OnboardingFeature extends StatelessWidget {
  const OnboardingFeature({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          switch (state.step) {
            case 0:
              return BackgroundLocationScreen(
                onOpenSettings: () =>
                    context.read<OnboardingBloc>().add(OnboardingNextStep()),
                onLater: () =>
                    context.read<OnboardingBloc>().add(OnboardingNextStep()),
                onBack: () {},
              );
            case 1:
            default:
              return OnboardingCompletionScreen(
                onGetStarted: onComplete,
                onAddFirstPlace: onComplete,
                onClose: onComplete,
              );
          }
        },
      ),
    );
  }
}

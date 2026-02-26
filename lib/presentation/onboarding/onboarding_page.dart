import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/onboarding_bloc.dart';
import 'bloc/onboarding_state.dart';
import 'widgets/onboarding_how_screen.dart';
import 'widgets/onboarding_why_screen.dart';

/// Onboarding flow: step 0 = Why, step 1 = How. Completion is handled by feature BlocListener.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        if (state.step == 0) {
          return const OnboardingWhyScreen();
        }
        return const OnboardingHowScreen();
      },
    );
  }
}

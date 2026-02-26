import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import 'onboarding_how_header.dart';
import 'onboarding_how_step_item.dart';
import 'onboarding_progress_dots.dart';

class OnboardingHowScreen extends StatelessWidget {
  const OnboardingHowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const OnboardingHowHeader(),
            SizedBox(height: AppSize.onboardingSpacer),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingXl3),
                children: const [
                  OnboardingHowStepItem(
                    stepNumber: 1,
                    title: 'Add your places on the map',
                    icon: Icons.map,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 2,
                    title: 'Grant location permission for background checks',
                    icon: Icons.near_me,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 3,
                    title: 'The app marks your presence automatically',
                    icon: Icons.verified_user,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 4,
                    title: 'Optionally sync with Google Calendar',
                    icon: Icons.event_repeat,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 5,
                    title: 'View and adjust your history in the Calendar tab',
                    icon: Icons.calendar_month,
                    showLine: false,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSize.spacingXl,
                AppSize.spacingXl,
                AppSize.spacingXl,
                AppSize.spacingXl4,
              ),
              child: Column(
                children: [
                  const OnboardingProgressDots(currentIndex: 1, total: 2),
                  const SizedBox(height: AppSize.spacingXl),
                  SizedBox(
                    width: double.infinity,
                    height: AppSize.buttonHeight,
                    child: FilledButton(
                      onPressed: () => context.read<OnboardingBloc>().add(
                        OnboardingComplete(),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppSize.radiusL),
                        ),
                      ),
                      child: Text(
                        'Get Started',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

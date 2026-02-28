import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import 'onboarding_how_header.dart';
import 'onboarding_how_step_item.dart';
import 'onboarding_progress_dots.dart';

class OnboardingHowScreen extends StatelessWidget {
  const OnboardingHowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                children: [
                  OnboardingHowStepItem(
                    stepNumber: 1,
                    title: l10n.howAddPlaces,
                    icon: Icons.map,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 2,
                    title: l10n.howLocationPermission,
                    icon: Icons.near_me,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 3,
                    title: l10n.howMarksPresence,
                    icon: Icons.verified_user,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 4,
                    title: l10n.howSyncCalendar,
                    icon: Icons.event_repeat,
                    showLine: true,
                  ),
                  OnboardingHowStepItem(
                    stepNumber: 5,
                    title: l10n.howViewHistory,
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
                        l10n.getStarted,
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

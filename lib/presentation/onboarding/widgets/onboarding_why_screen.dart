import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_state.dart';
import 'onboarding_why_actions.dart';
import 'onboarding_why_calendar_card.dart';
import 'onboarding_why_content.dart';
import 'onboarding_why_hero.dart';

class OnboardingWhyScreen extends StatelessWidget {
  const OnboardingWhyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                spacing: AppSize.spacingM,
                children: [
                  const OnboardingWhyHero(),
                  const OnboardingWhyContent(),
                  OnboardingWhyCalendarCard(
                    calendarSyncEnabled: state.calendarSyncEnabled,
                  ),
                  const OnboardingWhyActions(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

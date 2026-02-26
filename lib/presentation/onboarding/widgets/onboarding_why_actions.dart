import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:i_was_there/presentation/onboarding/widgets/onboarding_progress_dots.dart';

import '../../../core/theme/app_theme.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class OnboardingWhyActions extends StatelessWidget {
  const OnboardingWhyActions({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final secondaryColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSize.spacingL,
        AppSize.spacingXl,
        AppSize.spacingL,
        AppSize.spacingXl4,
      ),
      child: Column(
        children: [
          const OnboardingProgressDots(currentIndex: 0),
          const SizedBox(height: AppSize.spacingM),
          SizedBox(
            width: double.infinity,
            height: AppSize.buttonHeight,
            child: FilledButton(
              onPressed: () =>
                  context.read<OnboardingBloc>().add(OnboardingNextStep()),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.radiusL),
                ),
              ),
              child: Text(
                'Continue',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSize.spacingM3),
          SizedBox(
            width: double.infinity,
            height: AppSize.buttonHeightSm,
            child: TextButton(
              onPressed: () =>
                  context.read<OnboardingBloc>().add(OnboardingMaybeLater()),
              child: Text(
                'Maybe Later',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: secondaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';

class OnboardingHowHeader extends StatelessWidget {
  const OnboardingHowHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingXl,
        vertical: AppSize.spacingL,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: textColor,
            onPressed: () =>
                context.read<OnboardingBloc>().add(OnboardingBack()),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.howItWorks,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(width: AppSize.avatarLg),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/onboarding_completion/widgets/onboarding_completion_footer.dart';
import 'package:i_was_there/presentation/onboarding_completion/widgets/onboarding_completion_header.dart';
import 'package:i_was_there/presentation/onboarding_completion/widgets/onboarding_completion_status_card.dart';
import 'package:i_was_there/presentation/onboarding_completion/widgets/onboarding_completion_success_visual.dart';

/// Onboarding completion (HTML: on_boarding_completion.html). Success state, status cards, Get Started / Add First Place.
class OnboardingCompletionPage extends StatelessWidget {
  const OnboardingCompletionPage({
    super.key,
    this.onGetStarted,
    this.onAddFirstPlace,
    this.onClose,
  });

  final VoidCallback? onGetStarted;
  final VoidCallback? onAddFirstPlace;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OnboardingCompletionHeader(
              onClose: onClose ?? () => Navigator.of(context).pop(),
              isDark: isDark,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    OnboardingCompletionSuccessVisual(isDark: isDark),
                    const SizedBox(height: 32),
                    Text(
                      "You're all set!",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Background tracking is now active. We'll automatically sync your visits to your Google Calendar.",
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    OnboardingCompletionStatusCard(
                      icon: Icons.location_on,
                      label: 'Location Status',
                      value: 'Active & Monitoring',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    OnboardingCompletionStatusCard(
                      icon: Icons.calendar_today,
                      label: 'Google Calendar',
                      value: 'Connected',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '"Tip: Add your office to start tracking your work hours."',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            OnboardingCompletionFooter(
              onGetStarted: onGetStarted ?? () => Navigator.of(context).pop(),
              onAddFirstPlace: onAddFirstPlace,
              theme: theme,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

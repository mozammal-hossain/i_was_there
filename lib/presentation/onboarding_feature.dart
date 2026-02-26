import 'package:flutter/material.dart';

import 'onboarding_completion/onboarding_completion_page.dart';

/// Onboarding flow: completion only (why use app, how to use). Permission is asked when adding a place.
/// Calls [onComplete] when the user finishes (Get Started or Add First Place).
class OnboardingFeature extends StatelessWidget {
  const OnboardingFeature({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    return OnboardingCompletionPage(
      onGetStarted: onComplete,
      onAddFirstPlace: onComplete,
      onClose: onComplete,
    );
  }
}

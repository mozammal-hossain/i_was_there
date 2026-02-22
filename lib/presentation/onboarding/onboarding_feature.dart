import 'package:flutter/material.dart';
import 'widgets/background_location_screen.dart';
import 'widgets/onboarding_completion_screen.dart';

/// Onboarding flow: foreground/background location permission → completion.
/// Calls [onComplete] when the user finishes (Get Started or Add First Place).
class OnboardingFeature extends StatefulWidget {
  const OnboardingFeature({super.key, required this.onComplete});

  final Future<void> Function() onComplete;

  @override
  State<OnboardingFeature> createState() => _OnboardingFeatureState();
}

class _OnboardingFeatureState extends State<OnboardingFeature> {
  int _step = 0;

  void _next() {
    setState(() => _step++);
  }

  void _goToMain() {
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    switch (_step) {
      case 0:
        return BackgroundLocationScreen(
          onOpenSettings: _next,
          onLater: _next,
          onBack: () {},
        );
      case 1:
        return OnboardingCompletionScreen(
          onGetStarted: _goToMain,
          onAddFirstPlace: _goToMain,
          onClose: _goToMain,
        );
      default:
        return OnboardingCompletionScreen(
          onGetStarted: _goToMain,
          onAddFirstPlace: _goToMain,
          onClose: _goToMain,
        );
    }
  }
}

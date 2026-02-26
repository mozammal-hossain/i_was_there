import 'package:flutter/material.dart';

/// "Why use this app" section on onboarding completion.
class OnboardingCompletionWhySection extends StatelessWidget {
  const OnboardingCompletionWhySection({
    super.key,
    required this.theme,
    required this.isDark,
  });

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final bodyColor = isDark
        ? const Color(0xFF94A3B8)
        : const Color(0xFF64748B);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why use this app?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Define places like home, office, or gym. The app automatically records whether you were at each place each day, and you can optionally sync "I was there" to Google Calendar so it\'s all visible in one place.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: bodyColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

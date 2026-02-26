import 'package:flutter/material.dart';

/// "How to use it" section on onboarding completion.
class OnboardingCompletionHowSection extends StatelessWidget {
  const OnboardingCompletionHowSection({
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
    final steps = [
      'Add places (name + location on map or address)',
      'When adding your first place, grant location permission so the app can check presence in the background',
      'The app checks periodically and marks each day as present or not at each place',
      'Optionally connect Google Calendar in Settings to sync visits',
      'Use the Calendar tab to see history and correct any day via manual attendance',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to use it',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 12),
        ...steps.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${e.key + 1}.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: bodyColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    e.value,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: bodyColor,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

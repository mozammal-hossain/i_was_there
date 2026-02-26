import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class OnboardingWhyContent extends StatelessWidget {
  const OnboardingWhyContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bodyColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            'Why I Was There',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Define your important places and automatically record your presence each day. Focus on your fitness goals while we handle the tracking.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: bodyColor,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

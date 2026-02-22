import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Shown when the user has no tracked places (PRD R1). Encourages adding the first place.
class NoPlacePage extends StatelessWidget {
  const NoPlacePage({super.key, required this.onAddPlace});

  final VoidCallback onAddPlace;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              Icon(
                Icons.place_outlined,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.6),
              ),
              const SizedBox(height: 24),
              Text(
                'No places yet',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add a place to start tracking your weekly attendance.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
              const Spacer(flex: 2),
              FilledButton.icon(
                onPressed: onAddPlace,
                icon: const Icon(Icons.add, size: 22),
                label: const Text('Add your first place'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}

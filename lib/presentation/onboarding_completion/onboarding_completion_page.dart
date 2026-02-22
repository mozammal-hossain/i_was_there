import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

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
            _OnboardingCompletionHeader(
              onClose: onClose ?? () => Navigator.of(context).pop(),
              isDark: isDark,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    _OnboardingCompletionSuccessVisual(isDark: isDark),
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
                    _OnboardingCompletionStatusCard(
                      icon: Icons.location_on,
                      label: 'Location Status',
                      value: 'Active & Monitoring',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 16),
                    _OnboardingCompletionStatusCard(
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
            _OnboardingCompletionFooter(
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

class _OnboardingCompletionHeader extends StatelessWidget {
  const _OnboardingCompletionHeader({
    required this.onClose,
    required this.isDark,
  });

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Text(
            'STEP 3 OF 3',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _OnboardingCompletionSuccessVisual extends StatelessWidget {
  const _OnboardingCompletionSuccessVisual({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.3),
              width: 4,
            ),
          ),
          child: Icon(Icons.check_circle, size: 64, color: AppColors.primary),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight,
                width: 4,
              ),
            ),
            child: Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnboardingCompletionStatusCard extends StatelessWidget {
  const _OnboardingCompletionStatusCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary.withValues(alpha: 0.05)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? AppColors.primary.withValues(alpha: 0.1)
              : const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 24),
        ],
      ),
    );
  }
}

class _OnboardingCompletionFooter extends StatelessWidget {
  const _OnboardingCompletionFooter({
    required this.onGetStarted,
    this.onAddFirstPlace,
    required this.theme,
    required this.isDark,
  });

  final VoidCallback onGetStarted;
  final VoidCallback? onAddFirstPlace;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton(
              onPressed: onGetStarted,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: AppColors.primary.withValues(alpha: 0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Get Started',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: onAddFirstPlace,
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark
                      ? const Color(0xFF334155)
                      : const Color(0xFFE2E8F0),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.add_location_alt, size: 20),
              label: const Text(
                'Add Your First Place',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Background location permission guide (HTML: background_location.html). Step 2/3, Open Settings / I'll do this later.
class BackgroundLocationScreen extends StatelessWidget {
  const BackgroundLocationScreen({
    super.key,
    this.onOpenSettings,
    this.onLater,
    this.onBack,
  });

  final VoidCallback? onOpenSettings;
  final VoidCallback? onLater;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _BackgroundLocationHeader(
              onBack: onBack ?? () => Navigator.of(context).pop(),
              isDark: isDark,
            ),
            _BackgroundLocationProgress(isDark: isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BackgroundLocationHeroIllustration(isDark: isDark),
                    const SizedBox(height: 24),
                    Text(
                      "Enable 'Allow all the time'",
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'To automatically sync your physical presence with Google Calendar every 10 minutes, we need background location access even when the app is closed.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF64748B),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _BackgroundLocationStepsSection(
                      theme: theme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
            _BackgroundLocationFooter(
              onOpenSettings: onOpenSettings,
              onLater: onLater,
              theme: theme,
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundLocationHeader extends StatelessWidget {
  const _BackgroundLocationHeader({
    required this.onBack,
    required this.isDark,
  });

  final VoidCallback onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF334155).withValues(alpha: 0.5)
                  : const Color(0xFFF1F5F9),
            ),
          ),
          Expanded(
            child: Text(
              'Location Permission',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _BackgroundLocationProgress extends StatelessWidget {
  const _BackgroundLocationProgress({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(child: _ProgressBar(filled: true, isDark: isDark)),
          const SizedBox(width: 4),
          Expanded(child: _ProgressBar(filled: true, isDark: isDark)),
          const SizedBox(width: 4),
          Expanded(child: _ProgressBar(filled: false, isDark: isDark)),
        ],
      ),
    );
  }
}

class _BackgroundLocationHeroIllustration extends StatelessWidget {
  const _BackgroundLocationHeroIllustration({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 220),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF334155) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Container(
                    height: 8,
                    width: 80,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 12,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 12,
                width: 120,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                      color: AppColors.primary.withValues(alpha: 0.1),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Allow all the time',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF475569)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 8,
                    width: 100,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF475569)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundLocationStepsSection extends StatelessWidget {
  const _BackgroundLocationStepsSection({
    required this.theme,
    required this.isDark,
  });

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.info_outline, color: AppColors.primary, size: 22),
            const SizedBox(width: 8),
            Text(
              'How to enable:',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _StepRow(
          number: 1,
          text: "Tap 'Open Settings' below",
          isDark: isDark,
          isLast: false,
        ),
        _StepRow(
          number: 2,
          text: "Go to Permissions > Location",
          isDark: isDark,
          isLast: false,
        ),
        _StepRow(
          number: 3,
          text: "Select 'Allow all the time'",
          isDark: isDark,
          isLast: true,
          highlight: true,
        ),
      ],
    );
  }
}

class _BackgroundLocationFooter extends StatelessWidget {
  const _BackgroundLocationFooter({
    this.onOpenSettings,
    this.onLater,
    required this.theme,
    required this.isDark,
  });

  final VoidCallback? onOpenSettings;
  final VoidCallback? onLater;
  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.bgDarkGray : AppColors.bgWarmLight,
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton.icon(
                onPressed: onOpenSettings ??
                    () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening system settings…'),
                        ),
                      );
                    },
                icon: const Icon(Icons.open_in_new, size: 20),
                label: const Text(
                  'Open Settings',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: onLater ?? () => Navigator.of(context).pop(),
              child: Text(
                "I'll do this later",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your data is only used for calendar synchronization and is fully encrypted. We never share your location with third parties.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.filled, required this.isDark});

  final bool filled;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: filled
            ? AppColors.primary
            : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.text,
    required this.isDark,
    required this.isLast,
    this.highlight = false,
  });

  final int number;
  final String text;
  final bool isDark;
  final bool isLast;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: highlight
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.1),
              border: Border.all(
                color: highlight
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.2),
                width: highlight ? 2 : 1,
              ),
              boxShadow: highlight
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        blurRadius: 15,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$number',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? const Color(0xFFE2E8F0)
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

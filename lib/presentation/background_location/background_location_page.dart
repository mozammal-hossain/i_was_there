import 'package:flutter/material.dart';
import 'package:i_was_there/presentation/background_location/widgets/background_location_footer.dart';
import 'package:i_was_there/presentation/background_location/widgets/background_location_header.dart';
import 'package:i_was_there/presentation/background_location/widgets/background_location_hero_illustration.dart';
import 'package:i_was_there/presentation/background_location/widgets/background_location_progress.dart';
import 'package:i_was_there/presentation/background_location/widgets/background_location_steps_section.dart';

/// Background location permission guide (HTML: background_location.html). Step 2/3, Open Settings / I'll do this later.
class BackgroundLocationPage extends StatelessWidget {
  const BackgroundLocationPage({
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
            BackgroundLocationHeader(
              onBack: onBack ?? () => Navigator.of(context).pop(),
              isDark: isDark,
            ),
            BackgroundLocationProgress(isDark: isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 24,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BackgroundLocationHeroIllustration(isDark: isDark),
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
                    BackgroundLocationStepsSection(
                      theme: theme,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),
            BackgroundLocationFooter(
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

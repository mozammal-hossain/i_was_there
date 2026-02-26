import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class SettingsFooter extends StatelessWidget {
  const SettingsFooter({super.key, required this.theme, required this.isDark});

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSize.spacingXl),
        child: Text(
          'Your privacy is our priority. We only use calendar access to help you track your fitness consistency.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontSize: AppSize.fontSmall,
          ),
        ),
      ),
    );
  }
}

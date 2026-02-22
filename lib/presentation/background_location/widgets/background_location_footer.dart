import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class BackgroundLocationFooter extends StatelessWidget {
  const BackgroundLocationFooter({
    super.key,
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

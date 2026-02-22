import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceSaveSection extends StatelessWidget {
  const AddEditPlaceSaveSection({
    super.key,
    required this.isDark,
    required this.onSave,
  });

  final bool isDark;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sync,
              size: 14,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              'Updates sync with Google Calendar',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF64748B)
                    : const Color(0xFF94A3B8),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

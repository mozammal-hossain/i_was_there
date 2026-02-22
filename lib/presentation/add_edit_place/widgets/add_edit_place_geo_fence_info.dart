import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceGeofenceInfo extends StatelessWidget {
  const AddEditPlaceGeofenceInfo({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'A 20m geofence ensures accurate attendance tracking while maintaining privacy and battery efficiency.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark
                    ? const Color(0xFF94A3B8)
                    : const Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

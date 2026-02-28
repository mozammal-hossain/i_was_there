import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';

class ManualAttendancePlaceRow extends StatelessWidget {
  const ManualAttendancePlaceRow({
    super.key,
    required this.place,
    required this.present,
    required this.isDark,
    required this.icon,
    required this.onChanged,
    this.enabled = true,
  });

  final Place place;
  final bool present;
  final bool isDark;
  final IconData icon;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: AppSize.spacingM),
      padding: const EdgeInsets.all(AppSize.spacingL),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF334155).withValues(alpha: 0.4)
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppSize.radiusXl),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.avatarLg,
            height: AppSize.avatarLg,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF475569)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Icon(
              icon,
              size: AppSize.iconL,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: AppSize.spacingL2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      place.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                        fontSize: AppSize.fontTitle,
                      ),
                    ),
                    const SizedBox(width: AppSize.spacingM),
                    Icon(
                      Icons.sync,
                      size: AppSize.iconS,
                      color: isDark
                          ? const Color(0xFF64748B)
                          : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
                const SizedBox(height: AppSize.spacingXs),
                Text(
                  place.address.isNotEmpty ? place.address : 'No address',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? const Color(0xFF64748B)
                        : const Color(0xFF64748B),
                    fontSize: AppSize.fontSmall,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: present,
            onChanged: enabled ? onChanged : null,
            activeTrackColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

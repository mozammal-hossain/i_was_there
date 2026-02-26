import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/domain/places/entities/place.dart';

class DashboardPlaceCard extends StatelessWidget {
  const DashboardPlaceCard({
    super.key,
    required this.place,
    required this.isDark,
    required this.onTap,
  });

  final Place place;
  final bool isDark;
  final VoidCallback onTap;

  static IconData _iconForPlace(Place place) {
    final n = place.name.toLowerCase();
    if (n.contains('gym') || n.contains('fitness')) {
      return Icons.fitness_center;
    }
    if (n.contains('yoga') || n.contains('studio')) {
      return Icons.self_improvement;
    }
    return Icons.apartment;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSize.spacingM3),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSize.radiusCard),
        child: Padding(
          padding: const EdgeInsets.all(AppSize.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: AppSize.avatarLg,
                    height: AppSize.avatarLg,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? 0.2 : 0.1,
                      ),
                      borderRadius: BorderRadius.circular(AppSize.radiusXl),
                    ),
                    child: Icon(
                      _iconForPlace(place),
                      color: AppColors.primary,
                      size: AppSize.iconL,
                    ),
                  ),
                  const SizedBox(width: AppSize.spacingL),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: AppSize.spacingXs),
                        Text(
                          place.syncStatus.label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark
                                ? const Color(0xFF94A3B8)
                                : const Color(0xFF64748B),
                            fontSize: AppSize.fontSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: isDark
                        ? const Color(0xFF475569)
                        : const Color(0xFFCBD5E1),
                  ),
                ],
              ),
              const SizedBox(height: AppSize.spacingL),
              Row(
                children: [
                  const SizedBox(width: AppSize.spacingS),
                  ...['M', 'T', 'W', 'T', 'F', 'S', 'S'].asMap().entries.map((
                    e,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSize.spacingXs,
                      ),
                      child: Text(
                        e.value,
                        style: const TextStyle(
                          fontSize: AppSize.fontCaption,
                          fontWeight: FontWeight.bold,
                          letterSpacing: AppSize.letterSpacingLg,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: AppSize.spacingM),
              Row(
                children: List.generate(7, (i) {
                  final present = place.weeklyPresence[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSize.radiusS),
                    child: Container(
                      width: AppSize.dotMd,
                      height: AppSize.dotMd,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: present
                            ? AppColors.primary
                            : (isDark
                                  ? AppColors.neutralDotDark
                                  : AppColors.neutralDot),
                        boxShadow: present
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: AppSize.spacingM,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

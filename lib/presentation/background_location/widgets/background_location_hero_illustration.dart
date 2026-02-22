import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class BackgroundLocationHeroIllustration extends StatelessWidget {
  const BackgroundLocationHeroIllustration({
    super.key,
    required this.isDark,
  });

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
              _HeroLocationBarRow(isDark: isDark),
              const SizedBox(height: 12),
              _HeroSkeletonBar(isDark: isDark, fullWidth: true),
              const SizedBox(height: 8),
              _HeroSkeletonBar(isDark: isDark, fullWidth: false),
              const SizedBox(height: 16),
              _HeroOptionRow(
                isSelected: true,
                label: 'Allow all the time',
                isDark: isDark,
              ),
              const SizedBox(height: 8),
              _HeroOptionRow(
                isSelected: false,
                label: null,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroLocationBarRow extends StatelessWidget {
  const _HeroLocationBarRow({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}

class _HeroSkeletonBar extends StatelessWidget {
  const _HeroSkeletonBar({required this.isDark, required this.fullWidth});

  final bool isDark;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: fullWidth ? double.infinity : 120,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF475569)
            : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class _HeroOptionRow extends StatelessWidget {
  const _HeroOptionRow({
    required this.isSelected,
    required this.label,
    required this.isDark,
  });

  final bool isSelected;
  final String? label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : null,
          ),
          child: isSelected
              ? Center(
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
              : null,
        ),
        const SizedBox(width: 12),
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
          )
        else
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
    );
  }
}

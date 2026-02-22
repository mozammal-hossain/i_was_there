import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class BackgroundLocationStepsSection extends StatelessWidget {
  const BackgroundLocationStepsSection({
    super.key,
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
          _StepNumberCircle(number: number, highlight: highlight),
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

class _StepNumberCircle extends StatelessWidget {
  const _StepNumberCircle({required this.number, required this.highlight});

  final int number;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

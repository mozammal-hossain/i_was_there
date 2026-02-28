import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class BackgroundLocationProgress extends StatelessWidget {
  const BackgroundLocationProgress({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingL,
        vertical: AppSize.spacingM,
      ),
      child: Row(
        children: [
          Expanded(child: _ProgressBar(filled: true, isDark: isDark)),
          const SizedBox(width: AppSize.spacingS),
          Expanded(child: _ProgressBar(filled: true, isDark: isDark)),
          const SizedBox(width: AppSize.spacingS),
          Expanded(child: _ProgressBar(filled: false, isDark: isDark)),
        ],
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
      height: AppSize.progressHeight,
      decoration: BoxDecoration(
        color: filled
            ? AppColors.primary
            : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
        borderRadius: BorderRadius.circular(AppSize.radiusS),
      ),
    );
  }
}

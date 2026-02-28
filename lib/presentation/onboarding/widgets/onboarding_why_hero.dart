import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class OnboardingWhyHero extends StatelessWidget {
  const OnboardingWhyHero({super.key});

  static const String _illustrationUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAQ_CMpzY9Y1iM7xJFTNOZxyV8KbYO0z9SAc1KqNpo4luB5ApzFtIjLLmPDCx1YKeU1N44jxbag167HqNQFT8LirIpuTzKsyGEcoU9Gb_zm3T2ka89bRpz0ycjrTSfmmaukuO4IHnsodX1j-0RP3wCU6SRPdeIzxb9GRsF8goK9ssrjFzocC0RsbwIFTGXHINJx2ATVtX4K2bidz5kFv1NkkP4KEQgFv0tRlSJLkaddqBaQk1E0dVvhJ8WRtZyZuwK8s4yu6H-4gUsN';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSize.spacingL,
        vertical: AppSize.spacingXl,
      ),
      child: Container(
        constraints: const BoxConstraints(minHeight: AppSize.heroMinHeight),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSize.radiusL),
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: AppSize.spacingS,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          _illustrationUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: AppSize.heroMinHeight,
          errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(
              Icons.place,
              size: AppSize.iconXl3,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

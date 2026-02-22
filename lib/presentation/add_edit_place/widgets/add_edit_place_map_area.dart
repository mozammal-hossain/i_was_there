import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceMapArea extends StatelessWidget {
  const AddEditPlaceMapArea({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Icon(
              Icons.map_outlined,
              size: 64,
              color: (isDark
                  ? const Color(0xFF475569)
                  : const Color(0xFF94A3B8)),
            ),
          ),
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.4),
                width: 1,
              ),
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 2,
                    height: 12,
                    color: AppColors.primary.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

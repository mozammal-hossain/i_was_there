import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceMyLocationButton extends StatelessWidget {
  const AddEditPlaceMyLocationButton({
    super.key,
    required this.isLoading,
    required this.onTap,
  });

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppSize.spacingL,
      right: AppSize.spacingL,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(AppSize.radiusCard),
          child: Container(
            width: AppSize.avatarMd,
            height: AppSize.avatarMd,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF1E293B).withValues(alpha: 0.9)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(AppSize.radiusXl3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: AppSize.spacingM,
                  offset: const Offset(0, AppSize.spacingXs),
                ),
              ],
            ),
            child: isLoading
                ? Padding(
                    padding: const EdgeInsets.all(AppSize.spacingM2),
                    child: CircularProgressIndicator(
                      strokeWidth: AppSize.spacingXs,
                    ),
                  )
                : const Icon(
                    Icons.my_location,
                    size: AppSize.iconM2,
                    color: Color(0xFF64748B),
                  ),
          ),
        ),
      ),
    );
  }
}

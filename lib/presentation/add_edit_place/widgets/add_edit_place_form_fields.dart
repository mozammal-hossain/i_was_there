import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/l10n/app_localizations.dart';

class AddEditPlaceFormFields extends StatelessWidget {
  const AddEditPlaceFormFields({
    super.key,
    required this.isDark,
    required this.nameController,
    required this.addressController,
    required this.locationLoading,
    required this.onUseCurrentLocation,
    required this.onSearchAddress,
  });

  final bool isDark;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final bool locationLoading;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onSearchAddress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.name,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSize.spacingM),
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.enterPlaceName,
          ),
          style: TextStyle(
            fontSize: AppSize.fontTitle,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: AppSize.spacingL2),
        Text(
          AppLocalizations.of(context)!.address,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSize.spacingM),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.searchAddress,
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.primary,
              size: AppSize.iconM,
            ),
            suffixIcon: locationLoading
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSize.spacingM3,
                    ),
                    child: SizedBox(
                      width: AppSize.iconS2,
                      height: AppSize.iconS2,
                      child: const CircularProgressIndicator(
                        strokeWidth: AppSize.spacingXs,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.primary,
                      size: AppSize.iconM2,
                    ),
                    onPressed: onSearchAddress,
                    tooltip: AppLocalizations.of(context)!.searchAddressTooltip,
                  ),
          ),
          style: TextStyle(
            fontSize: AppSize.fontTitle,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => onSearchAddress(),
        ),
        const SizedBox(height: AppSize.spacingL),
        TextButton.icon(
          onPressed: locationLoading ? null : onUseCurrentLocation,
          icon: locationLoading
              ? SizedBox(
                  width: AppSize.iconS2,
                  height: AppSize.iconS2,
                  child: const CircularProgressIndicator(
                    strokeWidth: AppSize.spacingXs,
                    color: AppColors.primary,
                  ),
                )
              : const Icon(
                  Icons.near_me,
                  size: AppSize.iconS2,
                  color: AppColors.primary,
                ),
          label: Text(
            AppLocalizations.of(context)!.useMyCurrentLocation,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: AppSize.fontBody,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

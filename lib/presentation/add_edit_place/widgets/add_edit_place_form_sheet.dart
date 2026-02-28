import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_form_fields.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_geo_fence_info.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_save_section.dart';
import 'package:i_was_there/presentation/add_edit_place/widgets/add_edit_place_sheet_handle.dart';

class AddEditPlaceFormSheet extends StatelessWidget {
  const AddEditPlaceFormSheet({
    super.key,
    required this.isDark,
    required this.nameController,
    required this.addressController,
    required this.locationLoading,
    required this.onUseCurrentLocation,
    required this.onSearchAddress,
    required this.onSave,
  });

  final bool isDark;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final bool locationLoading;
  final VoidCallback onUseCurrentLocation;
  final VoidCallback onSearchAddress;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.bgWarmLight,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSize.radiusSheet),
        ),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: AppSize.spacingXl,
            offset: const Offset(0, -AppSize.spacingM),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSize.spacingXl,
            AppSize.spacingM3,
            AppSize.spacingXl,
            AppSize.spacingXl + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddEditPlaceSheetHandle(isDark: isDark),
              const SizedBox(height: AppSize.spacingXl),
              AddEditPlaceFormFields(
                isDark: isDark,
                nameController: nameController,
                addressController: addressController,
                locationLoading: locationLoading,
                onUseCurrentLocation: onUseCurrentLocation,
                onSearchAddress: onSearchAddress,
              ),
              const SizedBox(height: AppSize.spacingL),
              AddEditPlaceGeofenceInfo(isDark: isDark),
              const SizedBox(height: AppSize.spacingXl),
              AddEditPlaceSaveSection(isDark: isDark, onSave: onSave),
            ],
          ),
        ),
      ),
    );
  }
}

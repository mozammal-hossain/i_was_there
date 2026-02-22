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
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF475569) : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AddEditPlaceSheetHandle(isDark: isDark),
              const SizedBox(height: 24),
              AddEditPlaceFormFields(
                isDark: isDark,
                nameController: nameController,
                addressController: addressController,
                locationLoading: locationLoading,
                onUseCurrentLocation: onUseCurrentLocation,
                onSearchAddress: onSearchAddress,
              ),
              const SizedBox(height: 16),
              AddEditPlaceGeofenceInfo(isDark: isDark),
              const SizedBox(height: 24),
              AddEditPlaceSaveSection(isDark: isDark, onSave: onSave),
            ],
          ),
        ),
      ),
    );
  }
}

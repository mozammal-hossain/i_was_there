import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceFormFields extends StatelessWidget {
  const AddEditPlaceFormFields({
    super.key,
    required this.isDark,
    required this.nameController,
    required this.addressController,
    required this.locationLoading,
    required this.onUseCurrentLocation,
  });

  final bool isDark;
  final TextEditingController nameController;
  final TextEditingController addressController;
  final bool locationLoading;
  final VoidCallback onUseCurrentLocation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'NAME',
          style: theme.textTheme.labelMedium?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: 'Enter place name'),
          style: TextStyle(
            fontSize: 17,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'ADDRESS',
          style: theme.textTheme.labelMedium?.copyWith(
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: 'Search address...',
            prefixIcon: Icon(Icons.search, color: AppColors.primary, size: 20),
          ),
          style: TextStyle(
            fontSize: 17,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: locationLoading ? null : onUseCurrentLocation,
          icon: locationLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                )
              : const Icon(Icons.near_me, size: 18, color: AppColors.primary),
          label: const Text(
            'Use my current location',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

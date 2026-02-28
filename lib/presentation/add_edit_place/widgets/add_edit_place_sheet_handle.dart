import 'package:flutter/material.dart';

import 'package:i_was_there/core/theme/app_theme.dart';

class AddEditPlaceSheetHandle extends StatelessWidget {
  const AddEditPlaceSheetHandle({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppSize.handleWidth,
        height: AppSize.handleHeight,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(AppSize.radiusXs),
        ),
      ),
    );
  }
}

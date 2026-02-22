import 'package:flutter/material.dart';

class AddEditPlaceSheetHandle extends StatelessWidget {
  const AddEditPlaceSheetHandle({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

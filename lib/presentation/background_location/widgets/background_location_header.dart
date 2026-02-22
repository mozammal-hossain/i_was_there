import 'package:flutter/material.dart';
import 'package:i_was_there/core/theme/app_theme.dart';

class BackgroundLocationHeader extends StatelessWidget {
  const BackgroundLocationHeader({
    super.key,
    required this.onBack,
    required this.isDark,
  });

  final VoidCallback onBack;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : const Color(0xFF0F172A),
            ),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? const Color(0xFF334155).withValues(alpha: 0.5)
                  : const Color(0xFFF1F5F9),
            ),
          ),
          Expanded(
            child: Text(
              'Location Permission',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

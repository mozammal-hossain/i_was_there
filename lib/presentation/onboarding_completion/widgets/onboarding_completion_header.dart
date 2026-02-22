import 'package:flutter/material.dart';

class OnboardingCompletionHeader extends StatelessWidget {
  const OnboardingCompletionHeader({
    super.key,
    required this.onClose,
    required this.isDark,
  });

  final VoidCallback onClose;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            ),
          ),
          Text(
            'STEP 3 OF 3',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

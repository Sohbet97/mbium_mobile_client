import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class SupportQuestionRowWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool showBackground;
  final bool showDivider;

  const SupportQuestionRowWidget({
    super.key,
    required this.text,
    this.onTap,
    this.showBackground = true,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final row = GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: showBackground
              ? AppColors.primaryGreen.withValues(alpha: 0.06)
              : null,
          borderRadius: showBackground ? BorderRadius.circular(10) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 14, color: AppColors.lightTextPrimary),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, color: AppColors.lightTextSecondary, size: 16),
          ],
        ),
      ),
    );

    if (!showDivider) return row;

    return Column(
      children: [
        row,
        const Divider(height: 1),
      ],
    );
  }
}
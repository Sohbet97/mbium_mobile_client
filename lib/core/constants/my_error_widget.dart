import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class MyErrorWidget extends StatelessWidget {
  const MyErrorWidget({super.key, required this.error, this.onTap});

  final String error;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final iconBg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.errorRed.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.errorRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Näsazlyk ýüze çykdy',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: textSecondary,
                    fontSize: 13,
                  ),
            ),
            if (onTap != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.refresh_rounded, size: 20),
                  label: const Text('Gaýtadan synanyşmak'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

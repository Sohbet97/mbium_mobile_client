import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../themes/app_colors.dart';

class MyEmptyWidget extends StatelessWidget {
  const MyEmptyWidget({
    super.key,
    required this.emptyText,
    this.onTap,
    this.icon,
    this.buttonText,
  });

  final String emptyText;
  final VoidCallback? onTap;
  final IconData? icon;
  final String? buttonText;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
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
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                icon ?? Icons.inbox_outlined,
                size: 48,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              emptyText,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),

            if (onTap != null) ...[
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.add, size: 20, color: Colors.white),
                  label: Text(
                    buttonText ?? S.of(context).add,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

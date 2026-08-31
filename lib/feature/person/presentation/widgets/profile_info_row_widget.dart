import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProfileInfoRowWidget extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const ProfileInfoRowWidget({
    super.key,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: AppColors.lightTextPrimary),
            ),
            const Spacer(),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: AppColors.lightTextSecondary),
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 18, color: Colors.grey.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}
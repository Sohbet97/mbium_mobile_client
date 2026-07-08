import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';

class NotificationItemWidget extends StatelessWidget {
  final String category;
  final String shopName;
  final String message;
  final String? imageUrl;
  final String time;
  final bool isNew;

  const NotificationItemWidget({
    super.key,
    required this.category,
    required this.shopName,
    required this.message,
    this.imageUrl,
    required this.time,
    required this.isNew,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightTextSecondary,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              if (isNew)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: 6),
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
              const Icon(Icons.store_outlined,
                  size: 16, color: AppColors.primaryGreen),
              const SizedBox(width: 4),
              Text(shopName, style: textStyles.s13w600clBlack),
            ],
          ),
          const SizedBox(height: 6),

          Text(
            message,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
              height: 1.4,
            ),
          ),

          if (imageUrl != null && imageUrl!.isNotEmpty) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl!,
                width: double.infinity,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 140,
                  color: AppColors.navBarGrey,
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: AppColors.textLightGrey),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.navBarGrey,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.image_outlined,
                  color: AppColors.textLightGrey, size: 40),
            ),
          ],
        ],
      ),
    );
  }
}
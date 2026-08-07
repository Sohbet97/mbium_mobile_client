import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductGridShopRowWidget extends StatelessWidget {
  final String shopName;
  final bool isVerified;

  const ProductGridShopRowWidget({
    super.key,
    required this.shopName,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.storefront_outlined, size: 12, color: AppColors.lightTextSecondary),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            shopName,
            style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (isVerified) ...[
          const SizedBox(width: 3),
          const Icon(Icons.verified, size: 13, color: AppColors.primaryGreen),
        ],
      ],
    );
  }
}

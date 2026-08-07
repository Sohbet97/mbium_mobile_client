import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductGridPriceRowWidget extends StatelessWidget {
  final double price;
  final double? compareAtPrice;
  final String currency;
  final String? shopName;

  const ProductGridPriceRowWidget({
    super.key,
    required this.price,
    required this.currency,
    this.compareAtPrice,
    this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (compareAtPrice != null) ...[
          Text(
            '${compareAtPrice!.toStringAsFixed(0)} $currency',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.black.withOpacity(0.35),
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(height: 1),
        ],
        Text(
          '${price.toStringAsFixed(0)} $currency',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
            letterSpacing: -0.3,
          ),
        ),
        if (shopName != null && shopName!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.storefront_outlined, size: 11, color: AppColors.lightTextSecondary),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  shopName!,
                  style: const TextStyle(fontSize: 10, color: AppColors.lightTextSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
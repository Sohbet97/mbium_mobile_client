import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailShopWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductDetailShopWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final shop = product.shop;

    if (shop == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.bonusBannerGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.store_outlined,
                  color: AppColors.bonusBannerTextGreen, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(shop.name, style: textStyles.s13w600clBlack),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

class ShopsBannerWidget extends StatelessWidget {
  final ShopModel shop;
  final VoidCallback? onTap;

  const ShopsBannerWidget({super.key, this.onTap, required this.shop});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.bonusBannerGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: shop.logo == null
                  ? const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.bonusBannerTextGreen,
                      size: 26,
                    )
                  : Image.network(
                      shop.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.bonusBannerTextGreen,
                        size: 26,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        shop.localizedName,
                        style: textStyles.s16w600clBlack,
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 2),
                      Text(
                        shop.rating?.toString() ?? '0',
                        style: textStyles.s13w600clBlack,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    shop.localizedDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textLightGrey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

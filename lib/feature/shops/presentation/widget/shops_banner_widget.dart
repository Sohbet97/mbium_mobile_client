import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ShopsBannerWidget extends StatelessWidget {
  final ShopModel shop;
  final VoidCallback? onTap;

  const ShopsBannerWidget({super.key, this.onTap, required this.shop});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final l10n = S.of(context);
    final isVerified = shop.isVerified == true;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.bonusBannerGreen,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.navBarGrey),
              ),
              child: shop.logo == null
                  ? const Icon(
                      Icons.local_shipping_outlined,
                      color: AppColors.bonusBannerTextGreen,
                      size: 26,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(9),
                      child: Image.network(
                        shop.logo!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.local_shipping_outlined,
                          color: AppColors.bonusBannerTextGreen,
                          size: 26,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.localizedName,
                    style: textStyles.s16w600clBlack,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      if (isVerified) ...[
                        const Icon(Icons.verified, color: AppColors.primaryGreen, size: 14),
                        const SizedBox(width: 3),
                        Text(
                          l10n.tassyklanan,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      const Icon(Icons.star, color: AppColors.starYellow, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        '${shop.rating ?? '0.0'}/5.0',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (shop.type?.name != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      shop.type!.name!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (shop.localizedDescription.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      shop.localizedDescription,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textLightGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppColors.lightTextSecondary),
          ],
        ),
      ),
    );
  }
}
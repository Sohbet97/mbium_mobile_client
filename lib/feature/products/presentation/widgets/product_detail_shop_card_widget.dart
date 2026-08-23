import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailShopCardWidget extends StatelessWidget {
  final ProductDetailShop shop;
  final VoidCallback onOpenShop;
  final VoidCallback onMessage;

  const ProductDetailShopCardWidget({
    super.key,
    required this.shop,
    required this.onOpenShop,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.bonusBannerGreen,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: shop.logo != null && shop.logo!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(26),
                        child: Image.network(
                          shop.logo!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.store_outlined,
                            color: AppColors.bonusBannerTextGreen,
                            size: 26,
                          ),
                        ),
                      )
                    : const Icon(Icons.store_outlined,
                        color: AppColors.bonusBannerTextGreen, size: 26),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  shop.name,
                  style: textStyles.s16w600clBlack,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onMessage,
                  icon: const Icon(Icons.chat_bubble_outline, size: 16),
                  label: Text(l10n.habarlas),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryGreen,
                    side: const BorderSide(color: AppColors.primaryGreen),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onOpenShop,
                  icon: const Icon(Icons.storefront_outlined, size: 16),
                  label: Text(l10n.dukana_gir),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: AppColors.navWhite,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
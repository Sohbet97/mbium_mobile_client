import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/extensions/shop_detail_extension.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailHeaderWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailHeaderWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.bonusBannerGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: model.logo != null && model.logo!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      model.logo!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.store_outlined,
                        color: AppColors.bonusBannerTextGreen,
                        size: 32,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.store_outlined,
                    color: AppColors.bonusBannerTextGreen,
                    size: 32,
                  ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Expanded(
                      child: Text(
                        model.localizedName,
                        style: textStyles.s16w600clBlack,
                      ),
                    ),
                    if (model.isVerified == true) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          color: AppColors.bonusBannerTextGreen, size: 18),
                    ],
                  ],
                ),
                const SizedBox(height: 6),

                if (model.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star,
                          color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        model.rating!,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 6),

                // Açıklama
                if (model.localizedDescription.isNotEmpty)
                  Text(
                    model.localizedDescription,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.lightTextSecondary,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
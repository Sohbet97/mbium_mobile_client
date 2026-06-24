import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

class ShopDetailVerifiedWidget extends StatelessWidget {
  final ShopDetailModel model;

  const ShopDetailVerifiedWidget({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    if (model.isVerified != true) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppColors.bonusBannerTextGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.bonusBannerTextGreen.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified,
                color: AppColors.bonusBannerTextGreen, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tassyklanan Dükan',
                    style: textStyles.s13w600clBlack),
                const SizedBox(height: 2),
                const Text(
                  'Işewürlik şahsyýeti üstünlikli tassyklandy.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
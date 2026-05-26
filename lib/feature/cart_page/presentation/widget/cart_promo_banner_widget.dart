import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../../generated/l10n.dart';

class CartPromoBannerWidget extends StatelessWidget {
  const CartPromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppColors.bonusBannerGreen,
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              size: 18, color: AppColors.bonusBannerTextGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              children: [
                const Text(
                  'MUGT ELTIP BERMEK ',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bonusBannerTextGreen,
                  ),
                ),
                const Text(
                  'maks. 300TMT',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.aiTextBlack,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.access_time_outlined,
                    size: 14, color: AppColors.aiTextBlack),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.satyn_al,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.bonusBannerTextGreen,
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 12, color: AppColors.bonusBannerTextGreen),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
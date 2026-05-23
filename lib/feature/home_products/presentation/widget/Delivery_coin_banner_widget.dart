import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class DeliveryCoinBannerWidget extends StatelessWidget {
  final VoidCallback? onTap;

  const DeliveryCoinBannerWidget({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.bonusBannerGreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.local_shipping_outlined,
              color: AppColors.bonusBannerTextGreen,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                l10n.mugt_dastawka_mbium_coin,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.aiTextBlack,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: AppColors.bonusBannerTextGreen,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
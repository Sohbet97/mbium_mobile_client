import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class PromoBannerWidget extends StatelessWidget {
  const PromoBannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bonusBannerGreen,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Sol taraf - Mugt dastawka
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        color: AppColors.bonusBannerTextGreen,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.mugt_dastawka,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.aiTextBlack,
                              ),
                            ),
                            Text(
                              l10n.mbium_coin_bilen,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textLightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Orta ayraç çizgisi
              VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.4),
                indent: 8,
                endIndent: 8,
              ),

              // Sağ taraf - Baha goraglylygy
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: AppColors.bonusBannerTextGreen,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.baha_goraglylygy,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.aiTextBlack,
                              ),
                            ),
                            Text(
                              l10n.gune_cenli,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textLightGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
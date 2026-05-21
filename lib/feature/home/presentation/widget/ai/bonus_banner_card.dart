import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

class BonusBannerCard extends StatelessWidget {
  final String title;
  final String? coinIcon;
  final String? coinQuantity;
  const BonusBannerCard({
    super.key,
    required this.title,
    this.coinIcon,
    this.coinQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.bonusBannerBorderGreen, width: 0.3),
        color: AppColors.bonusBannerGreen,
      ),
      child: Row(
        children: [
          coinIcon != null
              ? Image.asset(coinIcon!, height: 15, width: 15)
              : SizedBox(),
          coinQuantity != null
              ? IntrinsicHeight(
                  child: Row(
                    children: [
                      SizedBox(width: 6),
                      Text(
                        coinQuantity!,
                        style: context.appTextStyles.s13w600clGreen.copyWith(
                          color: AppColors.bonusCoinGrey,
                        ),
                      ),
                      SizedBox(width: 6),
                      VerticalDivider(color: AppColors.bonusCoinGrey),
                    ],
                  ),
                )
              : SizedBox(),
          SvgIcon(
            iconName: 'assets/icons/star_icon.svg',
            color: AppColors.bonusBannerTextGreen,
            height: 12,
            width: 12,
          ),
          SizedBox(width: 9),
          Text(title, style: context.appTextStyles.s13w600clGreen),
        ],
      ),
    );
  }
}

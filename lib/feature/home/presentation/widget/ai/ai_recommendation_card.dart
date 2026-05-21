import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/app_text_styles.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

class AiRecommendationCard extends StatelessWidget {
  final AiRecommendationModel recommendation;
  const AiRecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(11),
      child: Ink(
        padding: EdgeInsets.symmetric(horizontal: 21, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(
            color: AppColors.bonusBannerBorderGreen,
            width: 0.3,
          ),
          color: AppColors.navWhite,
        ),
        child: Column(
          children: [
            Row(
              children: [
                SvgIcon(
                  iconName: 'assets/icons/search_icon.svg',
                  color: AppColors.bonusBannerTextGreen,
                  height: 15,
                  width: 15,
                ),
                SizedBox(width: 8),
                Text(
                  recommendation.title,
                  style: AppTextStyles.s13w600clGreen.copyWith(
                    color: AppColors.aiTextBlack,
                  ),
                ),
                Expanded(child: SizedBox()),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textLightGrey,
                  size: 15,
                ),
              ],
            ),
            SizedBox(height: 3),
            recommendation.subtitle != null
                ? Text(
                    recommendation.subtitle!,
                    style: AppTextStyles.s13w600clLightGrey,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}

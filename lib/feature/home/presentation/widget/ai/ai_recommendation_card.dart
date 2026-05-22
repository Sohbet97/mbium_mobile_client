import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/home/extensions/ai_recomendation.dart';
import 'package:mbium_mobile_client/feature/home/models/ai_recomendasion_model.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';

class AiRecommendationCard extends StatelessWidget {
  final AiRecommendationModel recommendation;
  const AiRecommendationCard({super.key, required this.recommendation});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 12),
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
                    recommendation.getTitle(context),
                    style: context.appTextStyles.s13w600clBlack,
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
              recommendation.getSubtitle(context) != null
                  ? Text(
                      recommendation.getSubtitle(context)!,
                      style: context.appTextStyles.s13w600clGreen.copyWith(
                        color: AppColors.textLightGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

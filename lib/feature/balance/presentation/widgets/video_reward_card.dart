import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class VideoRewardCard extends StatelessWidget {
  const VideoRewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Container(
      height: 136,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryGreen),
      ),
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgIcon(
                    iconName: 'assets/icons/video_efir.svg',
                    color: AppColors.textLightGrey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    localization.efirlerden_bayraklar_sowgatlar,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/home/presentation/widget/svg_icon.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class RewardCard extends StatelessWidget {
  const RewardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.secondaryGreen),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.efirlerden_bayrak_alyn,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  localization.gozleyji_we_sowgatlar_alyn,
                  style: TextStyle(
                    color: AppColors.balanceTextGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      localization.gech,
                      style: TextStyle(
                        color: AppColors.secondaryGreen,
                        fontSize: 18,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: AppColors.secondaryGreen,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SvgIcon(
            iconName: 'assets/icons/star_efir.svg',
            color: AppColors.secondaryGreen,
            height: 56,
            width: 56,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class MbiumBallarWidget extends StatelessWidget {
  const MbiumBallarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(41),
        border: Border.all(color: AppColors.secondaryGreen, width: 0.3),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          children: [
            Image.asset('assets/images/coin_image.png', height: 15, width: 15),
            SizedBox(width: 6),
            Text(
              localization.MBIUM_ballar,
              style: TextStyle(
                color: AppColors.balanceTextGrey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 14,
              child: VerticalDivider(color: AppColors.balanceTextGrey),
            ),
            Text(
              localization.bal_satyn_alnyshy,
              style: TextStyle(
                color: AppColors.secondaryGreen,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 2),
            Icon(Icons.arrow_forward, color: AppColors.secondaryGreen),
          ],
        ),
      ),
    );
  }
}

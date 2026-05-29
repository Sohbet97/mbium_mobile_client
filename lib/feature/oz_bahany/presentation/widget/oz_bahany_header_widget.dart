import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class OzBahanyHeaderWidget extends StatelessWidget {
  const OzBahanyHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            l10n.oz_bahany_sayla_title,
            style: textStyles.s16w600clBlack.copyWith(
              color: AppColors.bonusBannerTextGreen,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.oz_bahany_sayla_desc,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.sowda_teklip_sargytlaryn_in_meshgurlary,
            style: textStyles.s13w600clBlack,
          ),
        ],
      ),
    );
  }
}
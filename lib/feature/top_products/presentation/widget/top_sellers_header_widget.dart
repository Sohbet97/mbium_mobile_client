import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class TopSellersHeaderWidget extends StatelessWidget {
  const TopSellersHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );
    final localization = S.of(context);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.secondaryGreen.withValues(alpha: 0.2),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              localization.yer,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              localization.satyjy,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              localization.haryt_sany,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              localization.musderi_baha_reyting,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              localization.satys_sany,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              localization.kuryer_tizligi,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          Expanded(
            flex: 1,
            child: Text(
              localization.like,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              localization.umumy_ball,
              textAlign: TextAlign.center,
              style: textStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

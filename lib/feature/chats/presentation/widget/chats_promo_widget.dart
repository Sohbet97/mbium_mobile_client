import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../generated/l10n.dart';

class ChatsPromoWidget extends StatelessWidget {
  const ChatsPromoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.bonusBannerBorderGreen.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.verified_user_outlined,
              color: AppColors.bonusBannerTextGreen, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.aiTextBlack,
                    height: 1.5),
                children: [
                  TextSpan(text: l10n.sargyt_goragy_text),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: l10n.has_ginisleyin,
                    style: const TextStyle(
                      color: AppColors.bonusBannerTextGreen,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.bonusBannerTextGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
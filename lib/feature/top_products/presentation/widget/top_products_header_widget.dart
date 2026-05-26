import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import '../../../../generated/l10n.dart';

class TopProductsHeaderWidget extends StatelessWidget {
  const TopProductsHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      width: double.infinity,
      color: AppColors.primaryGreen,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        children: [

          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back,
                    color: AppColors.navWhite, size: 24),
              ),
              const Spacer(),
              Text(
                l10n.turkmenistanda_in_gowysy,
                style: textStyles.s16w600clBlack.copyWith(
                  color: AppColors.navWhite,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.search,
                color: AppColors.secondaryGreen,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.navWhite.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppColors.navWhite.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.kategoriyany_saylan,
                  style: const TextStyle(
                    color: AppColors.navWhite,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.navWhite, size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
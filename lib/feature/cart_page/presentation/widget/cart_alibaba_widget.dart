import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_features_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_payment_methods_widget.dart';
import '../../../../../generated/l10n.dart';

class CartAlibabaWidget extends StatelessWidget {
  const CartAlibabaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        l10n.alibaba_sargyt_goragy,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.aiTextBlack,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified_outlined,
                        size: 15,
                        color: AppColors.bonusBannerTextGreen,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.lightTextSecondary,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Text(
              l10n.alibaba_sargyt_goragy_desc,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
          ),
          const CartFeaturesWidget(),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: CartPaymentMethodsWidget(),
          ),
        ],
      ),
    );
  }
}

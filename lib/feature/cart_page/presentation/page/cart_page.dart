import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_alibaba_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_empty_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_features_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_payment_methods_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_promo_banner_widget.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_recommendation_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Text(
                    l10n.sebet,
                    style:
                        textStyles.s16w600clBlack.copyWith(fontSize: 20),
                  ),
                  const SizedBox(width: 4),
                 Text('(0)', style: textStyles.s16w600clBlack.copyWith(fontSize: 20)),
                const SizedBox(width: 8),   
                  
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.lightTextSecondary,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          l10n.us_a_eltip_bermek,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 11,
                          color: AppColors.lightTextSecondary,
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.favorite_border_outlined,
                    color: AppColors.lightTextSecondary,
                  ),
                ],
              ),
            ),


            const CartPromoBannerWidget(),
            const SizedBox(height: 16),

            const CartEmptyWidget(),
            const SizedBox(height: 16),

            const CartAlibabaWidget(),
            const SizedBox(height: 16),

            
            const CartRecommendationWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
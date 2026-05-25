import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../../generated/l10n.dart';

class CartEmptyWidget extends StatelessWidget {
  const CartEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/cart_box.png',
            width: 80,
            height: 80,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: AppColors.textLightGrey,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.sebedinez_bos,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}
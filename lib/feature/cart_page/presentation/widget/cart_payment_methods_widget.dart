import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import '../../../../../generated/l10n.dart';

class CartPaymentMethodsWidget extends StatelessWidget {
  const CartPaymentMethodsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            l10n.toleg_usullary,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(width: 10),
          const Text('💳', style: TextStyle(fontSize: 24)),
          const SizedBox(width: 8),
          const Text('🏦', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }
}
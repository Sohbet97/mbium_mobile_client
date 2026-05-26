import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            'assets/icons/empty_cart.svg',
            width: 80,
            height: 80,
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

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductGridPriceRowWidget extends StatelessWidget {
  final double price;
  final double? compareAtPrice;
  final String currency;

  const ProductGridPriceRowWidget({
    super.key,
    required this.price,
    required this.currency,
    this.compareAtPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            '${price.toStringAsFixed(0)} $currency',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: AppColors.alibabaOrange,
              letterSpacing: -0.4,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (compareAtPrice != null) ...[
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              '${compareAtPrice!.toStringAsFixed(0)} $currency',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black.withOpacity(0.35),
                decoration: TextDecoration.lineThrough,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

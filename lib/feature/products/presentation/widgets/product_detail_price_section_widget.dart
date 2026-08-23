import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductDetailPriceSectionWidget extends StatelessWidget {
  final double price;
  final String currency;
  final double? compareAtPrice;
  final List<String> tags;

  const ProductDetailPriceSectionWidget({
    super.key,
    required this.price,
    required this.currency,
    this.compareAtPrice,
    this.tags = const [],
  });

  int? get _discountPercent {
    if (compareAtPrice != null && compareAtPrice! > price) {
      return (((compareAtPrice! - price) / compareAtPrice!) * 100).round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${price.toStringAsFixed(2)} $currency',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
            if (discount != null) ...[
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.errorRed,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-$discount%',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.navWhite,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${compareAtPrice!.toStringAsFixed(2)} $currency',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textLightGrey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        if (tags.isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tags.map((t) => _TagBadge(label: t)).toList(),
          ),
        ],
      ],
    );
  }
}

class _TagBadge extends StatelessWidget {
  final String label;

  const _TagBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bonusBannerGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.diamond_outlined, size: 12, color: AppColors.bonusBannerTextGreen),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.bonusBannerTextGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
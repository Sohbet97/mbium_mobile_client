import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/extensions/product_extensions.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/splash/bloc/main_bloc.dart';

import '../../../../generated/l10n.dart';

/// Alibaba-style hero info card: title, tags, rating/sold/stock row, then a
/// large orange price with discount badge and an MOQ chip.
class ProductDetailPriceCardWidget extends StatelessWidget {
  const ProductDetailPriceCardWidget({super.key, required this.product});

  final ProductDetailModel product;

  int? get _discountPercent {
    if (product.compareAtPrice != null &&
        product.compareAtPrice! > product.price) {
      return (((product.compareAtPrice! - product.price) /
                  product.compareAtPrice!) *
              100)
          .round();
    }
    return null;
  }

  int? get _minOrderQuantity {
    final values = product.variants
        .map((v) => v.minOrderQuantity)
        .whereType<int>();
    return values.isEmpty ? null : values.reduce((a, b) => a < b ? a : b);
  }

  int? get _maxOrderQuantity {
    final values = product.variants
        .map((v) => v.maxOrderQuantity)
        .whereType<int>();
    return values.isEmpty ? null : values.reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final lang = AppLanguage.fromCode(
      context.read<MainBloc>().state.languageCode,
    );
    final discount = _discountPercent;
    final minQty = _minOrderQuantity;
    final maxQty = _maxOrderQuantity;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPrice(discount, minQty, maxQty, context),

          const SizedBox(height: 14),

          // const SizedBox(height: 14),
          // const Divider(height: 1),
          // const SizedBox(height: 14),
        ],
      ),
    );
  }

  Container _buildPrice(
    int? discount,
    int? minQty,
    int? maxQty,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).esasy_baha),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${product.price.toStringAsFixed(2)} ${product.currency}',
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryGreen,
                  letterSpacing: -0.5,
                ),
              ),
              if (discount != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  margin: const EdgeInsets.only(bottom: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryGreen,
                        AppColors.primaryGreen.withOpacity(0.7),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '-$discount%',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.navWhite,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (discount != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${product.compareAtPrice!.toStringAsFixed(2)} ${product.currency}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textLightGrey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${(product.compareAtPrice! - product.price).toStringAsFixed(2)} ${product.currency} tygşytlarsyňyz',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
          ],
          if (minQty != null || maxQty != null) ...[
            const SizedBox(height: 8),
            _MoqChip(minQty: minQty, maxQty: maxQty),
          ],

          if (product.priceTiers.isNotEmpty) ...[
            const SizedBox(height: 10),
            _WholesalePriceTable(
              tiers: product.priceTiers,
              basePrice: product.price,
              currency: product.currency,
            ),
          ],
        ],
      ),
    );
  }
}

/// Alibaba-style bulk-pricing strip: one column per quantity tier (plus the
/// base single-unit price when the first tier doesn't start at 1), unit
/// price on top and the qty range below, cheapest tier picked out in green.
class _WholesalePriceTable extends StatelessWidget {
  const _WholesalePriceTable({
    required this.tiers,
    required this.basePrice,
    required this.currency,
  });

  final List<PriceTier> tiers;
  final double basePrice;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final sorted = [...tiers]..sort((a, b) => a.minQty.compareTo(b.minQty));

    final columns = <_TierColumn>[
      if (sorted.first.minQty > 1)
        _TierColumn(label: '1-${sorted.first.minQty - 1}', price: basePrice),
      for (final tier in sorted)
        _TierColumn(
          label: tier.maxQty != null
              ? '${tier.minQty}-${tier.maxQty}'
              : '${tier.minQty}+',
          price: tier.unitPrice,
        ),
    ];

    final cheapestPrice = columns
        .map((c) => c.price)
        .reduce((a, b) => a < b ? a : b);

    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                size: 15,
                color: AppColors.alibabaOrange,
              ),
              const SizedBox(width: 6),
              const Text(
                'Toplum bahalar',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final column in columns)
                _TierCell(
                  column: column,
                  currency: currency,
                  isCheapest:
                      columns.length > 1 && column.price == cheapestPrice,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierColumn {
  const _TierColumn({required this.label, required this.price});

  final String label;
  final double price;
}

class _TierCell extends StatelessWidget {
  const _TierCell({
    required this.column,
    required this.currency,
    required this.isCheapest,
  });

  final _TierColumn column;
  final String currency;
  final bool isCheapest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${column.label} ${S.of(context).dan_den}',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${column.price.toStringAsFixed(2)} $currency',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: isCheapest ? AppColors.primaryGreen : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _MoqChip extends StatelessWidget {
  const _MoqChip({this.minQty, this.maxQty});

  final int? minQty;
  final int? maxQty;

  @override
  Widget build(BuildContext context) {
    final label = minQty != null && maxQty != null && minQty != maxQty
        ? 'MOQ $minQty-$maxQty'
        : 'MOQ ${minQty ?? maxQty}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.alibabaOrange.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 13,
            color: AppColors.alibabaOrange,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.alibabaOrange,
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bonusBannerGreen,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          color: AppColors.bonusBannerTextGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _RatingChip extends StatelessWidget {
  const _RatingChip({required this.rating, required this.reviewCount});

  final double rating;
  final int reviewCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star, color: AppColors.starYellow, size: 14),
        const SizedBox(width: 3),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _SoldChip extends StatelessWidget {
  const _SoldChip({required this.soldCount});

  final int soldCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.shopping_bag_outlined,
          size: 13,
          color: AppColors.lightTextSecondary,
        ),
        const SizedBox(width: 3),
        Text(
          '$soldCount satyldy',
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _StockChip extends StatelessWidget {
  const _StockChip({required this.stock, required this.sellWhenOutOfStock});

  final int stock;
  final bool sellWhenOutOfStock;

  @override
  Widget build(BuildContext context) {
    final Color color;
    final String label;

    if (stock == 0 && !sellWhenOutOfStock) {
      color = AppColors.errorRed;
      label = 'Stokda ýok';
    } else if (stock > 0 && stock <= 5) {
      color = Colors.orange;
      label = 'Az galdy: $stock';
    } else {
      color = AppColors.primaryGreen;
      label = 'Stokda bar: $stock';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inventory_2_outlined, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '·',
      style: TextStyle(color: AppColors.navBarGrey, fontSize: 16),
    );
  }
}

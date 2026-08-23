import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_3d_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_price_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shipping_chip_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_stats_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_turbo_badge_widget.dart';

import '../../../../generated/l10n.dart';

/// Full-width row card for vertical product lists — same premium card
/// language (white, rounded 16, soft border + shadow, shared badge/price/
/// stats widgets) as [ProductMassonGridItem] and [ProductHorizontalItem].
class ListProductItem extends StatelessWidget {
  const ListProductItem({super.key, required this.model});

  final ProductModel model;

  int? get _discountPercent {
    if (model.hasPriceRange) return null;
    if (model.compareAtPrice != null && model.compareAtPrice! > model.price) {
      final discount =
          ((model.compareAtPrice! - model.price) / model.compareAtPrice!) * 100;
      return discount.round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);
    final discount = _discountPercent;
    final imageUrl = model.primaryThumbnailUrl ?? '';

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/productDetail', arguments: model),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 92,
                height: 92,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.grey.shade50,
                      child: CachedNetworkImage(
                        imageUrl: imageUrl,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey[400],
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    if (model.turboActive || discount != null)
                      Positioned(
                        top: 4,
                        left: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (model.turboActive) ...[
                              const ProductGridTurboBadgeWidget(),
                              if (discount != null) const SizedBox(height: 4),
                            ],
                            if (discount != null)
                              ProductGridDiscountBadgeWidget(
                                discount: discount,
                              ),
                          ],
                        ),
                      ),
                    if (model.has3dModel)
                      const Positioned(
                        top: 4,
                        right: 4,
                        child: ProductGrid3dBadgeWidget(),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          model.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.25,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                      FavoriteItemWidget(product: model, size: 20),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ProductGridPriceRowWidget(
                    price: model.hasPriceRange ? model.minPrice : model.price,
                    compareAtPrice: model.hasPriceRange
                        ? null
                        : model.compareAtPrice,
                    currency: model.currency,
                  ),
                  const SizedBox(height: 4),
                  ProductGridStatsRowWidget(
                    rating: model.rating,
                    reviewCount: model.reviewCount,
                    soldCount: model.soldCount,
                  ),
                  if (model.moderationStatus == 1) ...[
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localization.tassyklanan,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Color.fromARGB(255, 17, 137, 235),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (model.deliveryTypes.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    ProductGridShippingChipWidget(
                      label: model.deliveryTypes.first.name,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

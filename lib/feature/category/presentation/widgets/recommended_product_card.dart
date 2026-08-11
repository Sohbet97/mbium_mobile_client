import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_3d_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_price_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shipping_chip_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shop_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_stats_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_turbo_badge_widget.dart';

class RecommendedProductCard extends StatelessWidget {
  final ProductModel product;
  final double width;

  const RecommendedProductCard({
    super.key,
    required this.product,
    this.width = 140,
  });

  int? get _discountPercent {
    if (product.compareAtPrice != null &&
        product.compareAtPrice! > product.price) {
      final discount =
          ((product.compareAtPrice! - product.price) / product.compareAtPrice!) *
          100;
      return discount.round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;
    final color = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productDetail', arguments: product);
      },
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.12), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.primaryThumbnailUrl ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) => Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textLightGrey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  right: 6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.turboActive) ...[
                            const ProductGridTurboBadgeWidget(),
                            if (discount != null) const SizedBox(height: 4),
                          ],
                          if (discount != null)
                            ProductGridDiscountBadgeWidget(discount: discount),
                        ],
                      ),
                      FavoriteItemWidget(
                        product: product,
                        size: 16,
                        padding: const EdgeInsets.all(5),
                        withBackground: true,
                      ),
                    ],
                  ),
                ),
                if (product.has3dModel)
                  const Positioned(
                    bottom: 6,
                    right: 6,
                    child: ProductGrid3dBadgeWidget(),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductGridPriceRowWidget(
                    price: product.price,
                    compareAtPrice: product.compareAtPrice,
                    currency: product.currency,
                  ),
                  if (product.deliveryTypes.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    ProductGridShippingChipWidget(
                      label: product.deliveryTypes.first.name,
                    ),
                  ],
                  const SizedBox(height: 3),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  ProductGridStatsRowWidget(
                    rating: product.rating,
                    reviewCount: product.reviewCount,
                    soldCount: product.soldCount,
                  ),
                  if (product.shop?.name != null) ...[
                    const SizedBox(height: 3),
                    ProductGridShopRowWidget(
                      shopName: product.shop!.name,
                      isVerified: product.shop?.isVerified == true,
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

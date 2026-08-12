import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_3d_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_turbo_badge_widget.dart';

/// Minimalist premium product tile for horizontal rails.
class ProductHorizontalItem extends StatelessWidget {
  const ProductHorizontalItem({
    super.key,
    required this.productModel,
    this.width = 140,
    this.height = 210,
  });

  final ProductModel productModel;
  final double width;
  final double height;

  String get _imageUrl => productModel.primaryThumbnailUrl ?? '';

  int? get _discountPercent {
    if (productModel.hasPriceRange) return null;
    if (productModel.compareAtPrice != null &&
        productModel.compareAtPrice! > productModel.price) {
      final discount =
          ((productModel.compareAtPrice! - productModel.price) /
              productModel.compareAtPrice!) *
          100;
      return discount.round();
    }
    return null;
  }

  Widget? get _secondary {
    final minQty = productModel.minOrderQuantity;
    final maxQty = productModel.maxOrderQuantity;
    if (minQty != null || maxQty != null) {
      return _InfoChip(
        icon: Icons.inventory_2_outlined,
        label: minQty != null && maxQty != null && minQty != maxQty
            ? 'MOQ $minQty-$maxQty'
            : 'MOQ ${minQty ?? maxQty}',
      );
    }
    if (productModel.deliveryTypes.isNotEmpty) {
      return _InfoChip(
        icon: Icons.local_shipping_outlined,
        label: productModel.deliveryTypes.first.name,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final discount = _discountPercent;
    final secondary = _secondary;

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productDetail', arguments: productModel);
      },
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TOP: PRODUCT IMAGE WITH BADGES ---
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: Colors.grey.shade50,
                    child: CachedNetworkImage(
                      imageUrl: _imageUrl,
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
                  if (productModel.turboActive || discount != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (productModel.turboActive) ...[
                            const ProductGridTurboBadgeWidget(),
                            if (discount != null) const SizedBox(height: 4),
                          ],
                          if (discount != null)
                            ProductGridDiscountBadgeWidget(discount: discount),
                        ],
                      ),
                    ),
                  if (productModel.has3dModel)
                    const Positioned(
                      top: 8,
                      right: 8,
                      child: ProductGrid3dBadgeWidget(),
                    ),
                ],
              ),
            ),

            // --- BOTTOM: PRODUCT INFO ---
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    productModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1F2937),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _PriceRow(productModel: productModel),
                  if (secondary != null) ...[
                    const SizedBox(height: 6),
                    secondary,
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

class _PriceRow extends StatelessWidget {
  final ProductModel productModel;

  const _PriceRow({required this.productModel});

  @override
  Widget build(BuildContext context) {
    if (productModel.hasPriceRange) {
      return Text(
        '${productModel.minPrice.toStringAsFixed(0)}-'
        '${productModel.maxPrice.toStringAsFixed(0)} ${productModel.currency}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.alibabaOrange,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Flexible(
          child: Text(
            '${productModel.price.toStringAsFixed(0)} ${productModel.currency}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.alibabaOrange,
            ),
          ),
        ),
        if (productModel.compareAtPrice != null) ...[
          const SizedBox(width: 4),
          Text(
            productModel.compareAtPrice!.toStringAsFixed(0),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade400,
              decoration: TextDecoration.lineThrough,
            ),
          ),
        ],
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 11, color: Colors.grey.shade500),
        const SizedBox(width: 3),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

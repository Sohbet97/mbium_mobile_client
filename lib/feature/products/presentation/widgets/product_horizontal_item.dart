import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';

class ProductHorizontalItem extends StatelessWidget {
  const ProductHorizontalItem({
    super.key,
    required this.productModel,
    this.width = 90,
  });
  final ProductModel productModel;
  final double width;

  String get _imageUrl => productModel.primaryThumbnailUrl ?? '';

  int? get _discountPercent {
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

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;
    final discount = _discountPercent;
    final color = Theme.of(context).cardColor;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/productDetail', arguments: productModel);
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.12), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
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
                  child: Image.network(
                    _imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[200]),
                  ),
                ),
                if (discount != null)
                  Positioned(
                    top: 6,
                    left: 6,
                    child: ProductGridDiscountBadgeWidget(discount: discount),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          '${productModel.price.toStringAsFixed(0)} ${productModel.currency}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: AppColors.alibabaOrange,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      if (productModel.compareAtPrice != null) ...[
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            productModel.compareAtPrice!.toStringAsFixed(0),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withValues(alpha: 0.35),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    productModel.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyles.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

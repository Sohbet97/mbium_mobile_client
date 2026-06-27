import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

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
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '-$discount%',
                        style: textStyles.displaySmall?.copyWith(),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ).copyWith(top: 8),
              child: Text(
                productModel.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textStyles.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ).copyWith(top: 4),
              child: Text(
                '${productModel.price.toStringAsFixed(2)} ${productModel.currency}',
                maxLines: 1,
                style: textStyles.bodyMedium?.copyWith(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

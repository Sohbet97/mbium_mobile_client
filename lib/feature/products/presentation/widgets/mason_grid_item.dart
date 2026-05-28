import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_control_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductMassonGridItem extends StatelessWidget {
  const ProductMassonGridItem({super.key, required this.product});

  final ProductModel product;

  String get _imageUrl {
    if (product.productMedia.isNotEmpty) {
      final media = product.productMedia.first;
      if (media is Map && media['url'] != null) {
        return media['url'].toString();
      }
    }
    return '';
  }

  int? get _discountPercent {
    if (product.compareAtPrice != null &&
        product.compareAtPrice! > product.price) {
      final discount =
          ((product.compareAtPrice! - product.price) /
              product.compareAtPrice!) *
          100;
      return discount.round();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final discount = _discountPercent;
    final color = Theme.of(context).cardColor;
    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/productDetail', arguments: product),
      child: Container(
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
          children: [
            Stack(
              children: [
                _imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        child: Image.network(
                          _imageUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          frameBuilder:
                              (context, child, frame, wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) return child;
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                          errorBuilder: (_, __, ___) => _placeholder(),
                        ),
                      )
                    : _placeholder(),

                Positioned(
                  top: 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (discount != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4B4B),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '-$discount%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                        )
                      else
                        const SizedBox.shrink(),

                      FavoriteItemWidget(
                        product: product,
                        size: 18,
                        padding: const EdgeInsets.all(6),
                        withBackground: true,
                      ),
                    ],
                  ),
                ),

                if (product.reviewCount > 0)
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            color: Color(0xFFFFB000),
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            product.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            ' (${product.reviewCount})',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: textStyles.s13w600clBlack.copyWith(
                      fontSize: 13,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (product.compareAtPrice != null) ...[
                              Text(
                                '${product.compareAtPrice!.toStringAsFixed(0)} ${product.currency}',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.35),
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(height: 1),
                            ],
                            Text(
                              '${product.price.toStringAsFixed(0)} ${product.currency}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryGreen,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      CartControlWidget(product: product),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
    height: 160,
    width: double.infinity,
    color: const Color.fromARGB(255, 216, 217, 219),
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textLightGrey,
      size: 32,
    ),
  );
}

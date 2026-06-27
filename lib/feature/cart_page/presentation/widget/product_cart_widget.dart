import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_control_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductCartWidget extends StatelessWidget {
  const ProductCartWidget({super.key, required this.product});

  final ProductModel product;

  String get _imageUrl {
    return product.primaryThumbnailUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return GestureDetector(
      onTap: () =>
          Navigator.pushNamed(context, '/productDetail', arguments: product),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image block ──────────────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _imageUrl.isNotEmpty
                    ? Image.network(
                        _imageUrl,
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(context),
                      )
                    : _placeholder(context),
              ),

              // Favorite — top right
              Positioned(
                top: 6,
                right: 6,
                child: FavoriteItemWidget(
                  product: product,
                  size: 18,
                  padding: const EdgeInsets.all(5),
                  withBackground: true,
                ),
              ),

              // Price badge — bottom left
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${product.price.toStringAsFixed(0)} ${product.currency}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              // Cart control — bottom right
              Positioned(
                bottom: 8,
                right: 8,
                child: CartControlWidget(product: product),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // ── Name ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              product.name,
              style: textStyles.s13w600clBlack.copyWith(fontSize: 12),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder(BuildContext context) => Container(
    width: double.infinity,
    height: 180,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Icon(
      Icons.image_not_supported_outlined,
      color: AppColors.textLightGrey,
      size: 36,
    ),
  );
}

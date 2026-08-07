import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_control_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_image_carousel_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_price_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shop_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_stats_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_tag_chip_widget.dart';

class ProductMassonGridItem extends StatefulWidget {
  const ProductMassonGridItem({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductMassonGridItem> createState() => _ProductMassonGridItemState();
}

class _ProductMassonGridItemState extends State<ProductMassonGridItem> {
  int _currentIndex = 0;

  ProductModel get product => widget.product;

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

  List<ProductMedia> get _displayMedia {
    final primary =
        product.productMedia.where((m) => m.role == 'primary').toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final gallery =
        product.productMedia.where((m) => m.role == 'gallery').toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    final combined = [...primary, ...gallery];
    return combined.isNotEmpty ? combined : product.productMedia;
  }

  void _goTo(int index, int mediaLength) {
    if (index < 0 || index >= mediaLength) return;
    setState(() => _currentIndex = index);
  }

  void _openDetail() {
    Navigator.pushNamed(context, '/productDetail', arguments: product);
  }

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final discount = _discountPercent;
    final color = Theme.of(context).cardColor;
    final media = _displayMedia;
    final hasMultipleImages = media.length > 1;

    return Container(
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
      // Bellik: Ok düwmeleri (arrow) şu daşky Stack-de "gardaş" hökmünde
      // ýerleşdirilýär (GestureDetector-yň içinde DÄL) — Flutter-de Stack
      // içindäki iň ýokarky element basylanda aşakdaky elemente asla
      // geçmeýär, şonuň üçin "detaile gir" bilen "surat çalyş" arasynda
      // çaknyşyk bolmaýar.
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _openDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ProductGridImageCarouselWidget(
                      media: media,
                      currentIndex: _currentIndex,
                    ),
                    // if (outOfStock) const ProductGridStockOverlayWidget(),
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (discount != null)
                            ProductGridDiscountBadgeWidget(discount: discount)
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
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProductGridPriceRowWidget(
                        price: product.price,
                        compareAtPrice: product.compareAtPrice,
                        currency: product.currency,
                      ),
                      if (product.category?.name != null) ...[
                        ProductGridTagChipWidget(label: product.category!.name),
                        const SizedBox(height: 6),
                      ],
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
                      ProductGridStatsRowWidget(
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                        soldCount: product.soldCount,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (product.shop?.name != null)
                            Expanded(
                              child: ProductGridShopRowWidget(
                                shopName: product.shop!.name,
                                isVerified: product.shop?.isVerified == true,
                              ),
                            )
                          else
                            const Spacer(),
                          CartControlWidget(product: product),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (hasMultipleImages) ...[
            Positioned(
              left: 0,
              top: 0,
              height: 136,
              child: _ArrowZone(
                icon: Icons.chevron_left,
                visible: _currentIndex > 0,
                onTap: () => _goTo(_currentIndex - 1, media.length),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              height: 136,
              child: _ArrowZone(
                icon: Icons.chevron_right,
                visible: _currentIndex < media.length - 1,
                onTap: () => _goTo(_currentIndex + 1, media.length),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ArrowZone extends StatelessWidget {
  final IconData icon;
  final bool visible;
  final VoidCallback onTap;

  const _ArrowZone({
    required this.icon,
    required this.visible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox(width: 26);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 26,
        alignment: Alignment.center,
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/cart_page/presentation/widget/cart_control_widget.dart';
import 'package:mbium_mobile_client/feature/favorite/presentation/favorite_item.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_3d_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_image_carousel_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_price_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shipping_chip_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_shop_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_stats_row_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_tag_chip_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_turbo_badge_widget.dart';

import '../../../../generated/l10n.dart';

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

  Color? _parseHexColor(String? hex) {
    if (hex == null) return null;
    var value = hex.trim();
    if (value.startsWith('#')) value = value.substring(1);
    if (value.length == 6) value = 'FF$value';
    if (value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    return parsed != null ? Color(parsed) : null;
  }

  // Esasy önümiň reňki + variantlaryň reňkleri (bar bolsa), gaýtalanmasyz.
  List<Color> get _swatchColors {
    final colors = <Color>[];
    final base = _parseHexColor(product.colorHex);
    if (base != null) colors.add(base);
    for (final variant in product.variants) {
      final variantColor = _parseHexColor(variant.colorHex);
      if (variantColor != null && !colors.contains(variantColor)) {
        colors.add(variantColor);
      }
    }
    return colors;
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
    final localization = S.of(context);

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
                      onPageChanged: (index) =>
                          setState(() => _currentIndex = index),
                    ),
                    // if (outOfStock) const ProductGridStockOverlayWidget(),
                    Positioned(
                      top: 8,
                      left: 8,
                      right: 8,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FavoriteItemWidget(
                            product: product,
                            size: 22,
                            padding: const EdgeInsets.all(6),
                            withBackground: true,
                          ),
                        ],
                      ),
                    ),

                    if (product.has3dModel)
                      const Positioned(
                        top: 8,
                        left: 8,
                        child: ProductGrid3dBadgeWidget(),
                      ),

                    if (product.turboActive)
                      Positioned(
                        bottom: 2,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              37,
                              37,
                              37,
                            ).withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'AD',
                            style: TextStyle(
                              color: AppColors.darkTextPrimary,
                              fontSize: 12,
                            ),
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

                      // if (product.category?.name != null) ...[
                      //   ProductGridTagChipWidget(label: product.category!.name),
                      //   const SizedBox(height: 6),
                      // ],
                      ProductGridPriceRowWidget(
                        price: product.price,
                        compareAtPrice: product.compareAtPrice,
                        currency: product.currency,
                      ),

                      if (product.shop?.hasBlueBadge == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 1),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                localization.tassyklanan,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(
                                Icons.verified,
                                size: 14,
                                color: const Color.fromARGB(255, 17, 137, 235),
                              ),
                            ],
                          ),
                        ),
                      ProductGridStatsRowWidget(
                        rating: product.rating,
                        reviewCount: product.reviewCount,
                        soldCount: product.soldCount,
                      ),

                      if (_swatchColors.isNotEmpty) ...[
                        Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: _swatchColors
                              .map(
                                (swatchColor) => Container(
                                  width: 18,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: swatchColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey.withValues(alpha: 0.3),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      if (product.deliveryTypes.isNotEmpty) ...[
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            if (product.deliveryTypes.isNotEmpty)
                              Expanded(
                                child: ProductGridShippingChipWidget(
                                  label: product.deliveryTypes.first.name,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 3),
                      ],
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

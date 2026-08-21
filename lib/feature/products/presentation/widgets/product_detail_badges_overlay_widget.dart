import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_discount_badge_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_grid_turbo_badge_widget.dart';

/// Floats discount/turbo badges over the (untouched) image gallery widget —
/// this widget must be a direct child of the [Stack] that wraps
/// `ProductDetailImagesWidget`, mirroring the badges shown on product cards.
class ProductDetailBadgesOverlay extends StatelessWidget {
  const ProductDetailBadgesOverlay({
    super.key,
    this.discount,
    this.turboActive = false,
  });

  final int? discount;
  final bool turboActive;

  @override
  Widget build(BuildContext context) {
    if (discount == null && !turboActive) return const SizedBox.shrink();

    return Positioned(
      top: 16,
      left: 82,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (turboActive) const ProductGridTurboBadgeWidget(),
          if (turboActive && discount != null) const SizedBox(height: 6),
          if (discount != null) ProductGridDiscountBadgeWidget(discount: discount!),
        ],
      ),
    );
  }
}

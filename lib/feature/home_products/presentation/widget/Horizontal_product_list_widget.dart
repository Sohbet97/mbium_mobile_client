import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/product_card_widget.dart';

import '../../../products/models/product_model.dart';

class HorizontalProductListWidget extends StatelessWidget {
  final List<ProductModel> products;
  final VoidCallback? onProductTap;

  const HorizontalProductListWidget({
    super.key,
    required this.products,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 155,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardWidget(
            imageUrl: product.currency,
            price: product.price.toString(),
            name: product.name,
            onTap: onProductTap,
          );
        },
      ),
    );
  }
}

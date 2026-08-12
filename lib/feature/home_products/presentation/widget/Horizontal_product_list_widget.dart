import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_horizontal_item.dart';

import '../../../products/models/product_model.dart';

class HorizontalProductListWidget extends StatelessWidget {
  final List<ProductModel> products;

  const HorizontalProductListWidget({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return ProductHorizontalItem(productModel: products[index]);
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/home_products/presentation/widget/horizontal_product_list_widget.dart';

import '../../../products/models/product_model.dart';

class ProductSectionWidget extends StatelessWidget {
  final Widget? banner;
  final List<ProductModel> products;

  const ProductSectionWidget({super.key, this.banner, required this.products});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (banner != null) ...[banner!, const SizedBox(height: 12)],
        HorizontalProductListWidget(products: products),
      ],
    );
  }
}

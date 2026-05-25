import 'package:flutter/material.dart';

import '../../models/product_model.dart';

class ProductMassonGridItem extends StatelessWidget {
  const ProductMassonGridItem({super.key, required this.product});
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsGeometry.all(8),
        child: Column(
          children: [
            Icon(Icons.photo, size: 100, color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 14, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}

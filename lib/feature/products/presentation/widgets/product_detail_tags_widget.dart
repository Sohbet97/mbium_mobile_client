import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailTagsWidget extends StatelessWidget {
  final ProductModel product;

  const ProductDetailTagsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    if (product.tags.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bellikler', style: textStyles.s13w600clBlack),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: product.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.navBarGrey,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
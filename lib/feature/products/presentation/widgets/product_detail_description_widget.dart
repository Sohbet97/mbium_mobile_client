import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class ProductDetailDescriptionWidget extends StatefulWidget {
  final ProductModel product;

  const ProductDetailDescriptionWidget({super.key, required this.product});

  @override
  State<ProductDetailDescriptionWidget> createState() =>
      _ProductDetailDescriptionWidgetState();
}

class _ProductDetailDescriptionWidgetState
    extends State<ProductDetailDescriptionWidget> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;
    final description = widget.product.description;

    if (description.isEmpty) return const SizedBox.shrink();

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Haryt barada', style: textStyles.s13w600clBlack),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.lightTextSecondary,
              height: 1.5,
            ),
            maxLines: _expanded ? null : 4,
            overflow: _expanded ? null : TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Text(
              _expanded ? 'Az göster' : 'Has giňişleýin',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
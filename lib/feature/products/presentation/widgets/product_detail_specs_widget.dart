import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/models/product_detail_model.dart';

import '../../../../generated/l10n.dart';

/// Zebra-striped product-specification sheet (SKU / weight / barcode /
/// category), Alibaba-style.
class ProductDetailSpecsWidget extends StatelessWidget {
  const ProductDetailSpecsWidget({super.key, required this.product});

  final ProductDetailModel product;

  @override
  Widget build(BuildContext context) {
    final localization = S.of(context);

    final rows = <_SpecRow>[
      if (product.sku.isNotEmpty)
        _SpecRow(label: 'SKU', value: product.sku, icon: Icons.qr_code_2_rounded),
      if (product.weight != null)
        _SpecRow(
          label: localization.agramy,
          value: '${product.weight} kg',
          icon: Icons.scale_outlined,
        ),
      if (product.barcode != null && product.barcode!.isNotEmpty)
        _SpecRow(
          label: localization.barkode,
          value: product.barcode!,
          icon: Icons.barcode_reader,
        ),
      if (product.category != null)
        _SpecRow(
          label: localization.category,
          value: product.category!.name,
          icon: Icons.category_outlined,
        ),
    ];

    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.list_alt_rounded,
                    size: 15,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Häsiýetnama',
                  style: context.appTextStyles.s13w600clBlack.copyWith(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++)
            Container(
              color: i.isEven ? Colors.grey.shade50 : Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(rows[i].icon, size: 15, color: Colors.grey.shade500),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 92,
                    child: Text(
                      rows[i].label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rows[i].value,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.lightTextPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SpecRow {
  const _SpecRow({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;
}

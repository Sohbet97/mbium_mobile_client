import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductSpecRow {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;

  const ProductSpecRow({
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
  });
}

class ProductDetailSpecsTableWidget extends StatelessWidget {
  final List<ProductSpecRow> rows;

  const ProductDetailSpecsTableWidget({super.key, required this.rows});

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) return const SizedBox.shrink();

    return Column(
      children: rows
          .map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  SizedBox(
                    width: 90,
                    child: Text(
                      r.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: r.onTap,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            r.value,
                            style: TextStyle(
                              fontSize: r.onTap != null ? 13 : 12,
                              fontWeight: FontWeight.w500,
                              color: r.onTap != null
                                  ? AppColors.primaryGreen
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          if (r.trailing != null) r.trailing!,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
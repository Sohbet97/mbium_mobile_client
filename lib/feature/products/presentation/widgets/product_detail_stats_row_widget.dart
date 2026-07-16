import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailStatsRowWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final int soldCount;
  final int stock;
  final bool sellWhenOutOfStock;

  const ProductDetailStatsRowWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.stock,
    required this.sellWhenOutOfStock,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.starYellow, size: 15),
        const SizedBox(width: 4),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
        ),
        const SizedBox(width: 14),
        const Icon(Icons.sell_outlined, size: 13, color: AppColors.lightTextSecondary),
        const SizedBox(width: 4),
        Text(
          '$soldCount ${l10n.satyldy}',
          style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
        ),
        const SizedBox(width: 14),
        _stockIndicator(l10n),
      ],
    );
  }

  Widget _stockIndicator(S l10n) {
    final Color color;
    final String label;
    final IconData icon;

    if (stock == 0 && !sellWhenOutOfStock) {
      color = AppColors.errorRed;
      label = l10n.stokda_yok;
      icon = Icons.error_outline;
    } else if (stock > 0 && stock <= 5) {
      color = Colors.orange;
      label = '${l10n.az_galdy}: $stock';
      icon = Icons.info_outline;
    } else {
      color = AppColors.primaryGreen;
      label = '${l10n.stokda_bar}: $stock';
      icon = Icons.check_circle_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
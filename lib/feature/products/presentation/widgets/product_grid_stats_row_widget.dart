import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';

class ProductGridStatsRowWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final int soldCount;

  const ProductGridStatsRowWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
  });

  @override
  Widget build(BuildContext context) {
    if (reviewCount <= 0 && soldCount <= 0) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.star_rounded, color: AppColors.starYellow, size: 13),
        const SizedBox(width: 2),
        Text(
          '${rating.toStringAsFixed(1)} ($reviewCount)',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.lightTextSecondary,
          ),
        ),

        const SizedBox(width: 6),
        Text(
          '·',
          style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.3)),
        ),
        const SizedBox(width: 6),

        Text(
          '$soldCount+ satyldy',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}

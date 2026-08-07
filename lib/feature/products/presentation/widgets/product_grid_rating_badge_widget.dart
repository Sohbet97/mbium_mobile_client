import 'package:flutter/material.dart';

class ProductGridRatingBadgeWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const ProductGridRatingBadgeWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFFFB000), size: 14),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
          Text(
            ' ($reviewCount)',
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w500, color: Colors.black.withOpacity(0.5)),
          ),
        ],
      ),
    );
  }
}
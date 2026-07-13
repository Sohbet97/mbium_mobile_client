import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';

class ShopDetailReviewItemWidget extends StatelessWidget {
  final String name;
  final int rating;
  final String comment;
  final String timeAgo;
  final String? avatarUrl;

  const ShopDetailReviewItemWidget({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
    required this.timeAgo,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = context.appTextStyles;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.lightBg,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(Icons.person_outline,
                    color: AppColors.lightTextSecondary, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: textStyles.s13w600clBlack),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (i) {
                    return Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      color: AppColors.starYellow,
                      size: 15,
                    );
                  }),
                ),
                const SizedBox(height: 6),
                Text(
                  comment,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.lightTextPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  timeAgo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.more_vert, color: AppColors.lightTextSecondary, size: 18),
        ],
      ),
    );
  }
}
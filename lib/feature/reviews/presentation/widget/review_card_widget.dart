import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/reviews/models/review_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReviewCardWidget extends StatelessWidget {
  final ReviewModel review;

  const ReviewCardWidget({super.key, required this.review});

  String _maskedUser(String userId) {
    if (userId.isEmpty) return '???';
    return '${userId.substring(0, 1).toUpperCase()}***';
  }

  String _timeAgo(DateTime date, S l10n) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays >= 30) return '${(diff.inDays / 30).floor()} ${l10n.ay_on}';
    if (diff.inDays >= 1) return '${diff.inDays} ${l10n.gun_on}';
    return l10n.hazir;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: List.generate(5, (i) {
                  return Icon(
                    i < review.rating ? Icons.star : Icons.star_border,
                    color: AppColors.starYellow,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(width: 8),
              Text(_maskedUser(review.userId), style: textStyles.s13w600clBlack),
              const SizedBox(width: 6),
              if (review.orderId > 0) ...[
                const Icon(Icons.verified, color: AppColors.bonusBannerTextGreen, size: 14),
                const SizedBox(width: 2),
                Expanded(
                  child: Text(
                    l10n.tassyklanan_satyn_alyjy,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.bonusBannerTextGreen),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.comment,
            style: const TextStyle(
                fontSize: 13, color: AppColors.lightTextPrimary, height: 1.4),
          ),
          const SizedBox(height: 8),
          Text(
            _timeAgo(review.createdAt, l10n),
            style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}
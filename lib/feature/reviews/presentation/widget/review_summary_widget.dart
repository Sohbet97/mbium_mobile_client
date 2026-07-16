import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReviewSummaryWidget extends StatelessWidget {
  final double averageRating;
  final int totalCount;
  
  final Map<int, int> starCounts;

  const ReviewSummaryWidget({
    super.key,
    required this.averageRating,
    required this.totalCount,
    required this.starCounts,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;
    final maxCount = starCounts.values.fold<int>(1, (a, b) => a > b ? a : b);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                l10n.umumy_baha,
                style: const TextStyle(fontSize: 12, color: AppColors.lightTextSecondary),
              ),
              const SizedBox(height: 4),
              Text(
                averageRating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (i) {
                  final filled = i < averageRating.round();
                  return Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: AppColors.starYellow,
                    size: 16,
                  );
                }),
              ),
              const SizedBox(height: 4),
              Text(
                '$totalCount ${l10n.teswirler}',
                style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final count = starCounts[star] ?? 0;
                final ratio = maxCount == 0 ? 0.0 : count / maxCount;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Text('$star', style: textStyles.s13w600clBlack),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: AppColors.starYellow, size: 13),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ratio,
                            minHeight: 6,
                            backgroundColor: AppColors.navBarGrey,
                            valueColor: const AlwaysStoppedAnimation(AppColors.primaryGreen),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$count',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.lightTextSecondary),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
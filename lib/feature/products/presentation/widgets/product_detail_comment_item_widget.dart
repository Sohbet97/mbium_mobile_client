import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailCommentItemWidget extends StatelessWidget {
  final CommentModel comment;

  const ProductDetailCommentItemWidget({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Avatar(name: comment.author.fullName),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.author.fullName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.lightTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(comment.createdAt),
                    style: const TextStyle(fontSize: 11, color: AppColors.lightTextSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (i) {
                      return Icon(
                        i < comment.rating ? Icons.star : Icons.star_border,
                        color: AppColors.starYellow,
                        size: 13,
                      );
                    }),
                  ),
                  if (comment.orderId > 0) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: AppColors.bonusBannerTextGreen, size: 12),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        l10n.tassyklanan_satyn_alyjy,
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.bonusBannerTextGreen),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                comment.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.lightTextSecondary,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}

class _Avatar extends StatelessWidget {
  final String name;

  const _Avatar({required this.name});

  String get _initials {
    if (name.isEmpty) return '?';
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      child: Text(
        _initials,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }
}
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
        _Avatar(name: comment.author.fullName, thumbnailUrl: comment.author.thumbnail),
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
              if (comment.isPending) ...[
                const SizedBox(height: 3),
                _PendingBadge(label: l10n.status_pending),
              ],
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
  final String? thumbnailUrl;

  const _Avatar({required this.name, this.thumbnailUrl});

  String get _initials {
    if (name.isEmpty) return '?';
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
        backgroundImage: NetworkImage(thumbnailUrl!),
      );
    }

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

class _PendingBadge extends StatelessWidget {
  final String label;

  const _PendingBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Colors.orange, fontWeight: FontWeight.w600),
      ),
    );
  }
}
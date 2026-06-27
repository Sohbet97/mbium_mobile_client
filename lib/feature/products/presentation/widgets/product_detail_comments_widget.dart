import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

class ProductDetailCommentsWidget extends StatefulWidget {
  final int productId;
  final int reviewCount;

  const ProductDetailCommentsWidget({
    super.key,
    required this.productId,
    required this.reviewCount,
  });

  @override
  State<ProductDetailCommentsWidget> createState() =>
      _ProductDetailCommentsWidgetState();
}

class _ProductDetailCommentsWidgetState
    extends State<ProductDetailCommentsWidget> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(
      LoadCommentsEvent(productId: widget.productId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 18,
                  color: AppColors.primaryGreen,
                ),
                const SizedBox(width: 8),
                Text(
                  'Teswirler',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightTextPrimary,
                  ),
                ),
                if (widget.reviewCount > 0) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.reviewCount}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/productReview',
                    arguments: widget.productId,
                  ),
                  child: const Row(
                    children: [
                      Text(
                        'Hemmesi',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: AppColors.primaryGreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Content ───────────────────────────────────────────────
          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                      strokeWidth: 2,
                    ),
                  ),
                );
              }

              if (state is CommentError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Ýüklenip bilinmedi',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ),
                );
              }

              if (state is CommentLoaded) {
                if (state.comments.isEmpty) {
                  return _EmptyPreview(productId: widget.productId);
                }

                final preview = state.comments.take(10).toList();

                return Column(
                  children: [
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      itemCount: preview.length,
                      separatorBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Divider(height: 1),
                      ),
                      itemBuilder: (context, index) =>
                          _PreviewCommentTile(comment: preview[index]),
                    ),
                    if (state.hasMore || widget.reviewCount > 10)
                      _SeeAllButton(productId: widget.productId),
                    const SizedBox(height: 4),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

// ─── Empty ────────────────────────────────────────────────────────────────────

class _EmptyPreview extends StatelessWidget {
  final int productId;

  const _EmptyPreview({required this.productId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            size: 40,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 10),
          Text(
            'Entek teswir ýok',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ilkinji teswiri siz ýazyň!',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }
}

// ─── See all button ───────────────────────────────────────────────────────────

class _SeeAllButton extends StatelessWidget {
  final int productId;

  const _SeeAllButton({required this.productId});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/productReview',
        arguments: productId,
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primaryGreen.withValues(alpha: 0.4),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Hemmesini görkez',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primaryGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Preview comment tile ──────────────────────────────────────────────────────

class _PreviewCommentTile extends StatelessWidget {
  final CommentModel comment;

  const _PreviewCommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MiniAvatar(author: comment.author),
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
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.lightTextSecondary,
                    ),
                  ),
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
              if (comment.replies.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    '${comment.replies.length} jogap',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
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

// ─── Mini avatar ──────────────────────────────────────────────────────────────

class _MiniAvatar extends StatelessWidget {
  final CommentAuthor author;

  const _MiniAvatar({required this.author});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(author.fullName);

    if (author.thumbnail != null && author.thumbnail!.isNotEmpty) {
      return CircleAvatar(
        radius: 16,
        backgroundImage: NetworkImage(author.thumbnail!),
        onBackgroundImageError: (_, __) {},
      );
    }

    return CircleAvatar(
      radius: 16,
      backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.12),
      child: Text(
        initials,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryGreen,
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }
}

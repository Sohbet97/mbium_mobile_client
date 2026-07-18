import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comment_item_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comments_empty_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comments_summary_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailCommentsWidget extends StatefulWidget {
  final int productId;
  final double rating;
  final int reviewCount;

  const ProductDetailCommentsWidget({
    super.key,
    required this.productId,
    required this.rating,
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
    context.read<CommentBloc>().add(LoadCommentsEvent(productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductDetailCommentsSummaryWidget(
            rating: widget.rating,
            reviewCount: widget.reviewCount,
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
            child: Row(
              children: [
                const Icon(Icons.chat_bubble_outline_rounded,
                    size: 18, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(l10n.teswirler, style: textStyles.s13w600clBlack),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/productReview',
                    arguments: widget.productId,
                  ),
                  child: Row(
                    children: [
                      Text(
                        l10n.hemmesi,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 2),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 12, color: AppColors.primaryGreen),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primaryGreen, strokeWidth: 2),
                  ),
                );
              }

             if (state is CommentError) {
            final isAuthError = state.errorMessage.contains('401');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Center(
                child: Text(
                  isAuthError ? l10n.teswir_giris_gerek : l10n.teswir_yuklenmedi,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                ),
              ),
            );
          }

              if (state is CommentLoaded) {
                if (state.comments.isEmpty) {
                  return const ProductDetailCommentsEmptyWidget();
                }

                final preview = state.comments.take(3).toList();

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
                          ProductDetailCommentItemWidget(comment: preview[index]),
                    ),
                    if (state.comments.length > 3 || state.hasMore)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(
                            context,
                            '/productReview',
                            arguments: widget.productId,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.primaryGreen.withValues(alpha: 0.4),
                                  width: 1.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                l10n.hemmesini_gorkez,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
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
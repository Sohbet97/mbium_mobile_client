import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comment_item_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comment_write_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comments_empty_widget.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comments_summary_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductReviewScreen extends StatefulWidget {
  final int productId;

  const ProductReviewScreen({super.key, required this.productId});

  @override
  State<ProductReviewScreen> createState() => _ProductReviewScreenState();
}

class _ProductReviewScreenState extends State<ProductReviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentsEvent(productId: widget.productId));
  }

  void _openWriteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<CommentBloc>(),
        child: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
          child: ProductDetailCommentWriteWidget(productId: widget.productId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.lightTextPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(l10n.teswirler, style: textStyles.s16w600clBlack),
        centerTitle: true,
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openWriteSheet,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: Text(l10n.teswir_goshmak),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: AppColors.navWhite,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentLoading || state is CommentInitial) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductDetailCommentsSummaryWidget(rating: 0, reviewCount: 0),
                  const Divider(height: 1),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }

          if (state is CommentError) {
            final isAuthError = state.errorMessage.contains('401');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ProductDetailCommentsSummaryWidget(rating: 0, reviewCount: 0),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                    child: Center(
                      child: Text(
                        isAuthError ? l10n.teswir_giris_gerek : l10n.teswir_yuklenmedi,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is! CommentLoaded) {
            return const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductDetailCommentsSummaryWidget(rating: 0, reviewCount: 0),
                  Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }

          final comments = state.comments;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailCommentsSummaryWidget(rating: 0, reviewCount: comments.length),
                const Divider(height: 1),
                const SizedBox(height: 12),
                if (comments.isEmpty)
                  const ProductDetailCommentsEmptyWidget()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        for (final c in comments)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductDetailCommentItemWidget(comment: c),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}

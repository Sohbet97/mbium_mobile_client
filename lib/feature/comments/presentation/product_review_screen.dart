import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/comments/bloc/comment_bloc.dart';
import 'package:mbium_mobile_client/feature/products/presentation/widgets/product_detail_comment_filter_chips_widget.dart';
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
  final ScrollController _scrollController = ScrollController();
  int? _ratingFilter;

  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(LoadCommentsEvent(productId: widget.productId));
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CommentBloc>().add(const LoadMoreCommentsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _averageRating(List comments) {
    if (comments.isEmpty) return 0.0;
    final total = comments.fold<int>(0, (sum, c) => sum + (c.rating as int));
    return total / comments.length;
  }

  Map<int, int> _starCounts(List comments) {
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final c in comments) {
      final r = c.rating as int;
      if (r >= 1 && r <= 5) counts[r] = (counts[r] ?? 0) + 1;
    }
    return counts;
  }

  void _openMoreFilters() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        final l10n = S.of(sheetContext);
        final textStyles = sheetContext.appTextStyles;
        Widget option(String label, int? value) {
          final selected = _ratingFilter == value;
          return ListTile(
            title: Text(
              label,
              style: selected
                  ? textStyles.s13w600clBlack.copyWith(color: AppColors.primaryGreen)
                  : textStyles.s13w600clBlack,
            ),
            trailing: selected ? const Icon(Icons.check, color: AppColors.primaryGreen) : null,
            onTap: () {
              setState(() => _ratingFilter = value);
              Navigator.pop(sheetContext);
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Text(l10n.tertiplemek, style: textStyles.s16w600clBlack),
              const SizedBox(height: 8),
              option(l10n.hemmesi, null),
              option('2 ★', 2),
              option('1 ★', 1),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _openWriteSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: context.read<CommentBloc>(),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 12,
            right: 12,
            top: 20,
          ),
          child: SafeArea(
            top: false,
            child: ProductDetailCommentWriteWidget(
              productId: widget.productId,
              orderId: 0, 
            ),
          ),
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
              const SizedBox(height: 12),
              ProductDetailCommentFilterChipsWidget(
                selectedRating: _ratingFilter,
                onSelect: (_) {},
                onMoreFiltersTap: () {},
              ),
              const SizedBox(height: 12),
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

          final allComments = state.comments;
          final avgRating = _averageRating(allComments);
          final starCounts = _starCounts(allComments);
          final filteredComments = _ratingFilter == null
              ? allComments
              : allComments.where((c) => c.rating == _ratingFilter).toList();

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductDetailCommentsSummaryWidget(
                  rating: avgRating,
                  reviewCount: allComments.length,
                  starCounts: starCounts,
                ),
                const Divider(height: 1),
                const SizedBox(height: 12),
                ProductDetailCommentFilterChipsWidget(
                  selectedRating: _ratingFilter,
                  onSelect: (rating) => setState(() => _ratingFilter = rating),
                  onMoreFiltersTap: _openMoreFilters,
                ),
                const SizedBox(height: 12),
                if (filteredComments.isEmpty)
                  const ProductDetailCommentsEmptyWidget()
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ...filteredComments.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: ProductDetailCommentItemWidget(comment: c),
                          ),
                        ),
                        if (state.isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
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
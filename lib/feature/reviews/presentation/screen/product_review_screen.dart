import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/reviews/bloc/review_bloc.dart';
import 'package:mbium_mobile_client/feature/reviews/data/review_repository.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_filter_chips_widget.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_list_widget.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_summary_widget.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_write_sheet_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductReviewScreen extends StatelessWidget {
  final int productId;
  final int orderId;
  final double averageRating;
  final int reviewCount;

  const ProductReviewScreen({
    super.key,
    required this.productId,
    required this.orderId,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  Widget build(BuildContext context) {
    // Bellik: main.dart-a ReviewRepository provider goşulmady, şonuň üçin
    // ProductRepository-iň bar bolan Dio-syny ulanyp, ýerli döretdim
    final dio = context.read<ProductRepository>().dio;

    return BlocProvider(
      create: (context) => ReviewBloc(repository: ReviewRepository(dio: dio))
        ..add(LoadReviewsEvent(productId: productId)),
      child: _ProductReviewView(
        productId: productId,
        orderId: orderId,
        averageRating: averageRating,
        reviewCount: reviewCount,
      ),
    );
  }
}

class _ProductReviewView extends StatefulWidget {
  final int productId;
  final int orderId;
  final double averageRating;
  final int reviewCount;

  const _ProductReviewView({
    required this.productId,
    required this.orderId,
    required this.averageRating,
    required this.reviewCount,
  });

  @override
  State<_ProductReviewView> createState() => _ProductReviewViewState();
}

class _ProductReviewViewState extends State<_ProductReviewView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<ReviewBloc>().add(const LoadMoreReviewsEvent());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
              onPressed: () => ReviewWriteSheetWidget.show(
                context,
                productId: widget.productId,
                orderId: widget.orderId,
              ),
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
      body: BlocBuilder<ReviewBloc, ReviewState>(
        builder: (context, state) {
          if (state is ReviewLoading || state is ReviewInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewError) {
            return Center(child: Text(state.message));
          }

          if (state is! ReviewLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final loaded = state;

          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReviewSummaryWidget(
                  averageRating: widget.averageRating,
                  totalCount: widget.reviewCount,
                  starCounts: loaded.starCounts,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ReviewFilterChipsWidget(
                    selectedRating: loaded.ratingFilter,
                    onSelect: (rating) =>
                        context.read<ReviewBloc>().setRatingFilter(rating),
                    onFilterTap: () {},
                  ),
                ),
                ReviewListWidget(state: loaded, scrollController: _scrollController),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
    );
  }
}
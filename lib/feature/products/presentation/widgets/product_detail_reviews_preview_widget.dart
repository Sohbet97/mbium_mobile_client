import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mbium_mobile_client/core/themes/app_colors.dart';
import 'package:mbium_mobile_client/core/themes/theme.dart';
import 'package:mbium_mobile_client/feature/products/data/product_repository.dart';
import 'package:mbium_mobile_client/feature/reviews/bloc/review_bloc.dart';
import 'package:mbium_mobile_client/feature/reviews/data/review_repository.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_card_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ProductDetailReviewsPreviewWidget extends StatelessWidget {
  final int productId;
  final int orderId;
  final double rating;
  final int reviewCount;
  final VoidCallback onSeeAll;

  const ProductDetailReviewsPreviewWidget({
    super.key,
    required this.productId,
    required this.orderId,
    required this.rating,
    required this.reviewCount,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    // Bellik: main.dart-a ReviewRepository provider goşulmady, şonuň üçin
    // ProductRepository-iň bar bolan Dio-syny ulanyp, ýerli döretdim
    final dio = context.read<ProductRepository>().dio;

    return BlocProvider(
      create: (context) => ReviewBloc(repository: ReviewRepository(dio: dio))
        ..add(LoadReviewsEvent(productId: productId)),
      child: _PreviewBody(reviewCount: reviewCount, onSeeAll: onSeeAll),
    );
  }
}

class _PreviewBody extends StatelessWidget {
  final int reviewCount;
  final VoidCallback onSeeAll;

  const _PreviewBody({required this.reviewCount, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final textStyles = context.appTextStyles;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: GestureDetector(
              onTap: onSeeAll,
              child: Row(
                children: [
                  Text(l10n.shops_st, style: textStyles.s13w600clBlack),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.lightTextSecondary),
                ],
              ),
            ),
          ),
          BlocBuilder<ReviewBloc, ReviewState>(
            builder: (context, state) {
              if (state is ReviewLoading || state is ReviewInitial) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppColors.primaryGreen),
                  ),
                );
              }

              if (state is ReviewLoaded) {
                if (state.reviews.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                    child: Text(
                      l10n.teswirler_heniz_yok,
                      style: const TextStyle(fontSize: 13, color: AppColors.lightTextSecondary),
                    ),
                  );
                }

                final preview = state.reviews.take(3).toList();
                return Column(
                  children: [
                    for (final review in preview) ReviewCardWidget(review: review),
                    const SizedBox(height: 8),
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
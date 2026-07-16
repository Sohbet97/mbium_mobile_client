import 'package:flutter/material.dart';
import 'package:mbium_mobile_client/feature/reviews/bloc/review_bloc.dart';
import 'package:mbium_mobile_client/feature/reviews/presentation/widget/review_card_widget.dart';
import 'package:mbium_mobile_client/generated/l10n.dart';

class ReviewListWidget extends StatelessWidget {
  final ReviewLoaded state;
  final ScrollController scrollController;

  const ReviewListWidget({
    super.key,
    required this.state,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final reviews = state.filteredReviews;

    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 60),
        child: Center(
          child: Text(l10n.teswirler_heniz_yok),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: reviews.length + (state.isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= reviews.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        return ReviewCardWidget(review: reviews[index]);
      },
    );
  }
}
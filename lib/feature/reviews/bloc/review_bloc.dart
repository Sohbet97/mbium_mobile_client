import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/reviews/data/review_repository.dart';
import 'package:mbium_mobile_client/feature/reviews/models/review_model.dart';

part 'review_event.dart';
part 'review_state.dart';

const _limit = 20;

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc({required this.repository}) : super(ReviewInitial()) {
    on<LoadReviewsEvent>(_onLoad);
    on<LoadMoreReviewsEvent>(_onLoadMore);
    on<SubmitReviewEvent>(_onSubmit);
  }

  Map<int, int> _computeStarCounts(List<ReviewModel> reviews) {
    final counts = <int, int>{1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
    for (final r in reviews) {
      if (r.rating >= 1 && r.rating <= 5) {
        counts[r.rating] = (counts[r.rating] ?? 0) + 1;
      }
    }
    return counts;
  }

  Future<void> _onLoad(LoadReviewsEvent event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final response = await repository.getProductReviews(
        productId: event.productId,
        limit: _limit,
        skip: 0,
      );
      emit(
        ReviewLoaded(
          productId: event.productId,
          reviews: response.reviews,
          ratingFilter: event.ratingFilter,
          skip: 0,
          limit: _limit,
          hasMore: response.hasMore(0, _limit),
          starCounts: _computeStarCounts(response.reviews),
        ),
      );
    } catch (e) {
      emit(ReviewError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreReviewsEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final current = state;
    if (current is! ReviewLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextSkip = current.skip + current.limit;
      final response = await repository.getProductReviews(
        productId: current.productId,
        limit: current.limit,
        skip: nextSkip,
      );
      final merged = [...current.reviews, ...response.reviews];
      emit(
        current.copyWith(
          reviews: merged,
          skip: nextSkip,
          isLoadingMore: false,
          hasMore: response.hasMore(nextSkip, current.limit),
          starCounts: _computeStarCounts(merged),
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSubmit(
    SubmitReviewEvent event,
    Emitter<ReviewState> emit,
  ) async {
    final previous = state;
    emit(ReviewSubmitting());
    try {
      await repository.createReview(event.request);
      emit(ReviewSubmitSuccess());
      if (previous is ReviewLoaded) {
        add(LoadReviewsEvent(productId: previous.productId));
      }
    } catch (e) {
      emit(ReviewSubmitError(message: e.toString()));
      if (previous is ReviewLoaded) emit(previous);
    }
  }

  void setRatingFilter(int? rating) {
    final current = state;
    if (current is ReviewLoaded) {
      emit(current.copyWith(ratingFilter: rating, clearRatingFilter: rating == null));
    }
  }
}
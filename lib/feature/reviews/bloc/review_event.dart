part of 'review_bloc.dart';

sealed class ReviewEvent extends Equatable {
  const ReviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadReviewsEvent extends ReviewEvent {
  final int productId;
  final int? ratingFilter;

  const LoadReviewsEvent({required this.productId, this.ratingFilter});

  @override
  List<Object?> get props => [productId, ratingFilter];
}

class LoadMoreReviewsEvent extends ReviewEvent {
  const LoadMoreReviewsEvent();
}

class SubmitReviewEvent extends ReviewEvent {
  final CreateReviewRequest request;

  const SubmitReviewEvent(this.request);

  @override
  List<Object?> get props => [request];
}
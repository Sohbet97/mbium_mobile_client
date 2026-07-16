part of 'review_bloc.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final int productId;
  final List<ReviewModel> reviews;
  final int? ratingFilter;
  final int skip;
  final int limit;
  final bool hasMore;
  final bool isLoadingMore;

  /// Ýüklenen teswirlerden hasap edilen ýyldyz paýlanyşy (0-index = 1★, ... 4-index = 5★)
  final Map<int, int> starCounts;

  const ReviewLoaded({
    required this.productId,
    required this.reviews,
    this.ratingFilter,
    required this.skip,
    required this.limit,
    required this.hasMore,
    this.isLoadingMore = false,
    required this.starCounts,
  });

  List<ReviewModel> get filteredReviews => ratingFilter == null
      ? reviews
      : reviews.where((r) => r.rating == ratingFilter).toList();

  ReviewLoaded copyWith({
    List<ReviewModel>? reviews,
    int? ratingFilter,
    bool clearRatingFilter = false,
    int? skip,
    bool? hasMore,
    bool? isLoadingMore,
    Map<int, int>? starCounts,
  }) {
    return ReviewLoaded(
      productId: productId,
      reviews: reviews ?? this.reviews,
      ratingFilter: clearRatingFilter ? null : (ratingFilter ?? this.ratingFilter),
      skip: skip ?? this.skip,
      limit: limit,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      starCounts: starCounts ?? this.starCounts,
    );
  }

  @override
  List<Object?> get props =>
      [productId, reviews, ratingFilter, skip, hasMore, isLoadingMore, starCounts];
}

class ReviewError extends ReviewState {
  final String message;
  const ReviewError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReviewSubmitting extends ReviewState {}

class ReviewSubmitSuccess extends ReviewState {}

class ReviewSubmitError extends ReviewState {
  final String message;
  const ReviewSubmitError({required this.message});

  @override
  List<Object?> get props => [message];
}
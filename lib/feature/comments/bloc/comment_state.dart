part of 'comment_bloc.dart';

sealed class CommentState extends Equatable {
  const CommentState();

  @override
  List<Object?> get props => [];
}

final class CommentInitial extends CommentState {}

final class CommentLoading extends CommentState {}

final class CommentLoaded extends CommentState {
  final List<CommentModel> comments;
  final int productId;
  final int skip;
  final bool hasMore;
  final bool isLoadingMore;

  const CommentLoaded({
    required this.comments,
    required this.productId,
    required this.skip,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  CommentLoaded copyWith({
    List<CommentModel>? comments,
    int? productId,
    int? skip,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CommentLoaded(
      comments: comments ?? this.comments,
      productId: productId ?? this.productId,
      skip: skip ?? this.skip,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [comments, productId, skip, hasMore, isLoadingMore];
}

final class CommentError extends CommentState {
  final String errorMessage;
  final int? productId;

  const CommentError({required this.errorMessage, this.productId});

  @override
  List<Object?> get props => [errorMessage, productId];
}

final class CommentSubmitting extends CommentState {}

final class CommentSubmitSuccess extends CommentState {}

final class CommentSubmitError extends CommentState {
  final String errorMessage;

  const CommentSubmitError({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
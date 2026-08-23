part of 'comment_bloc.dart';

sealed class CommentEvent extends Equatable {
  const CommentEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCommentsEvent extends CommentEvent {
  final int productId;

  const LoadCommentsEvent({required this.productId});

  @override
  List<Object?> get props => [productId];
}

final class LoadMoreCommentsEvent extends CommentEvent {
  const LoadMoreCommentsEvent();
}

final class RefreshCommentsEvent extends CommentEvent {
  const RefreshCommentsEvent();
}

final class SubmitCommentEvent extends CommentEvent {
  final CreateCommentRequest request;

  const SubmitCommentEvent(this.request);

  @override
  List<Object?> get props => [request];
}
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/comments/data/comment_repository.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

part 'comment_event.dart';
part 'comment_state.dart';

const _limit = 20;

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc({required this.repository}) : super(CommentInitial()) {
    on<LoadCommentsEvent>(_onLoad);
    on<LoadMoreCommentsEvent>(_onLoadMore);
    on<RefreshCommentsEvent>(_onRefresh);
    on<SubmitCommentEvent>(_onSubmit);
  }

  FutureOr<void> _onLoad(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final response = await repository.getProductComments(
        event.productId,
        limit: _limit,
        skip: 0,
      );
      emit(
        CommentLoaded(
          comments: response.comments,
          productId: event.productId,
          skip: 0,
          hasMore: response.hasMore(0, _limit),
        ),
      );
    } catch (e) {
      emit(CommentError(errorMessage: e.toString(), productId: event.productId));
    }
  }

  FutureOr<void> _onLoadMore(
    LoadMoreCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    final current = state;
    if (current is! CommentLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextSkip = current.skip + _limit;
      final response = await repository.getProductComments(
        current.productId,
        limit: _limit,
        skip: nextSkip,
      );
      emit(
        current.copyWith(
          comments: [...current.comments, ...response.comments],
          skip: nextSkip,
          isLoadingMore: false,
          hasMore: response.hasMore(nextSkip, _limit),
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  FutureOr<void> _onRefresh(
    RefreshCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    final current = state;
    if (current is! CommentLoaded) return;

    try {
      final response = await repository.getProductComments(
        current.productId,
        limit: _limit,
        skip: 0,
      );
      emit(
        current.copyWith(
          comments: response.comments,
          skip: 0,
          hasMore: response.hasMore(0, _limit),
          isLoadingMore: false,
        ),
      );
    } catch (_) {}
  }

  FutureOr<void> _onSubmit(
    SubmitCommentEvent event,
    Emitter<CommentState> emit,
  ) async {
    final previous = state;
    emit(CommentSubmitting());
    try {
      await repository.createComment(event.request);
      emit(CommentSubmitSuccess());
      add(LoadCommentsEvent(productId: event.request.productId));
    } catch (e) {
      emit(CommentSubmitError(errorMessage: e.toString()));
      if (previous is CommentLoaded) emit(previous);
    }
  }
}
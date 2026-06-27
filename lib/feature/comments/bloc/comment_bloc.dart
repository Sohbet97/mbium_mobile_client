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
  }

  FutureOr<void> _onLoad(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final comments = await repository.getProductComments(
        event.productId,
        limit: _limit,
        skip: 0,
      );
      emit(
        CommentLoaded(
          comments: comments,
          productId: event.productId,
          skip: 0,
          hasMore: comments.length >= _limit,
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
      final more = await repository.getProductComments(
        current.productId,
        limit: _limit,
        skip: nextSkip,
      );
      emit(
        current.copyWith(
          comments: [...current.comments, ...more],
          skip: nextSkip,
          isLoadingMore: false,
          hasMore: more.length >= _limit,
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
      final comments = await repository.getProductComments(
        current.productId,
        limit: _limit,
        skip: 0,
      );
      emit(
        current.copyWith(
          comments: comments,
          skip: 0,
          hasMore: comments.length >= _limit,
          isLoadingMore: false,
        ),
      );
    } catch (_) {}
  }
}

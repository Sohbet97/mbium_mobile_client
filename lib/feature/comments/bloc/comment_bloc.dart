import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/comments/data/comment_repository.dart';
import 'package:mbium_mobile_client/feature/comments/models/comment_model.dart';

part 'comment_event.dart';
part 'comment_state.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository repository;

  CommentBloc({required this.repository}) : super(CommentInitial()) {
    on<LoadCommentsEvent>(_onLoad);
    on<RefreshCommentsEvent>(_onRefresh);
    on<SubmitCommentEvent>(_onSubmit);
  }

  FutureOr<void> _onLoad(
    LoadCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    emit(CommentLoading());
    try {
      final response = await repository.getProductComments(event.productId);
      emit(
        CommentLoaded(
          comments: response.comments,
          productId: event.productId,
        ),
      );
    } catch (e) {
      emit(CommentError(errorMessage: e.toString(), productId: event.productId));
    }
  }

  FutureOr<void> _onRefresh(
    RefreshCommentsEvent event,
    Emitter<CommentState> emit,
  ) async {
    final current = state;
    if (current is! CommentLoaded) return;

    try {
      final response = await repository.getProductComments(current.productId);
      emit(current.copyWith(comments: response.comments));
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
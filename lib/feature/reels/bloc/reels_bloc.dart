import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/reels/data/reels_repository.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_filter_model.dart';
import 'package:mbium_mobile_client/feature/reels/models/reels_model.dart';

part 'reels_event.dart';
part 'reels_state.dart';

class ReelsBloc extends Bloc<ReelsEvent, ReelsState> {
  final ReelsRepository repository;

  CancelToken _cancelToken = CancelToken();

  ReelsBloc({required this.repository}) : super(ReelsInitial()) {
    on<LoadReels>(_onLoadReels);
    on<LoadMoreReels>(_onLoadMoreReels);
    on<RefreshReels>(_onRefreshReels);
  }

  Future<void> _onLoadReels(
    LoadReels event,
    Emitter<ReelsState> emit,
  ) async {
    _cancelToken.cancel();
    _cancelToken = CancelToken();

    emit(ReelsLoading());

    try {
      final filter = event.filter.resetPage();
      final response = await repository.getReels(
        filter,
        cancelToken: _cancelToken,
      );

      emit(ReelsLoaded(
        reels: response.reels,
        hasMore: response.hasMore(filter.page, filter.limit),
        filter: filter,
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(ReelsError(message: _errorMessage(e), filter: event.filter));
    } catch (e) {
      emit(ReelsError(message: e.toString(), filter: event.filter));
    }
  }

  Future<void> _onLoadMoreReels(
    LoadMoreReels event,
    Emitter<ReelsState> emit,
  ) async {
    final current = state;
    if (current is! ReelsLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextFilter = current.filter.copyWith(page: current.filter.page + 1);
      final response = await repository.getReels(
        nextFilter,
        cancelToken: _cancelToken,
      );

      emit(current.copyWith(
        reels: [...current.reels, ...response.reels],
        hasMore: response.hasMore(nextFilter.page, nextFilter.limit),
        isLoadingMore: false,
        filter: nextFilter,
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(current.copyWith(isLoadingMore: false));
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onRefreshReels(
    RefreshReels event,
    Emitter<ReelsState> emit,
  ) async {
    final current = state;
    final filter = current is ReelsLoaded
        ? current.filter.resetPage()
        : const ReelsFilterModel();

    add(LoadReels(filter));
  }

  String _errorMessage(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionError => 'Нет подключения к интернету',
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout =>
        'Превышено время ожидания',
      _ => e.response?.statusMessage ?? 'Ошибка загрузки',
    };
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/shops/data/shop_repository.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_filter_model.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_model.dart';

part 'shop_event.dart';
part 'shop_state.dart';

class ShopBloc extends Bloc<ShopEvent, ShopState> {
  final ShopRepository repository;

  CancelToken _cancelToken = CancelToken();

  ShopBloc({required this.repository}) : super(ShopInitial()) {
    on<LoadShops>(_onLoadShops);
    on<LoadMoreShops>(_onLoadMoreShops);
    on<RefreshShops>(_onRefreshShops);
  }

  Future<void> _onLoadShops(
    LoadShops event,
    Emitter<ShopState> emit,
  ) async {
    _cancelToken.cancel();
    _cancelToken = CancelToken();

    emit(ShopLoading());

    try {
      final filter = event.filter.resetPage();
      final response = await repository.getShops(
        filter,
        cancelToken: _cancelToken,
      );

      emit(ShopLoaded(
        shops: response.shops,
        hasMore: response.hasMore(filter.page, filter.limit),
        filter: filter,
      ));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(ShopError(message: _errorMessage(e), filter: event.filter));
    } catch (e) {
      emit(ShopError(message: e.toString(), filter: event.filter));
    }
  }

  Future<void> _onLoadMoreShops(
    LoadMoreShops event,
    Emitter<ShopState> emit,
  ) async {
    final current = state;
    if (current is! ShopLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextFilter = current.filter.copyWith(page: current.filter.page + 1);
      final response = await repository.getShops(
        nextFilter,
        cancelToken: _cancelToken,
      );

      emit(current.copyWith(
        shops: [...current.shops, ...response.shops],
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

  Future<void> _onRefreshShops(
    RefreshShops event,
    Emitter<ShopState> emit,
  ) async {
    final current = state;
    final filter = current is ShopLoaded
        ? current.filter.resetPage()
        : const ShopFilterModel();

    add(LoadShops(filter));
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

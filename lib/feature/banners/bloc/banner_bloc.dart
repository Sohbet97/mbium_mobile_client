import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/banners/data/banner_repository.dart';
import 'package:mbium_mobile_client/feature/banners/model/banner_model.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository repository;

  CancelToken _cancelToken = CancelToken();

  BannerBloc({required this.repository}) : super(BannerInitial()) {
    on<LoadBannersEvent>(_onLoadBanners);
  }

  Future<void> _onLoadBanners(
    LoadBannersEvent event,
    Emitter<BannerState> emit,
  ) async {
    _cancelToken.cancel();
    _cancelToken = CancelToken();

    emit(BannerLoading());

    try {
      final banners = await repository.getBanners(
        type: event.type,
        shopId: event.shopId,
        cancelToken: _cancelToken,
      );
      emit(BannerLoaded(banners: banners));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) return;
      emit(BannerError(message: e.response?.statusMessage ?? 'Ошибка загрузки'));
    } catch (e) {
      emit(BannerError(message: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _cancelToken.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/brands/data/brand_repository.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_filter.dart';
import 'package:mbium_mobile_client/feature/brands/models/brand_model.dart';

part 'brand_event.dart';
part 'brand_state.dart';

class BrandBloc extends Bloc<BrandEvent, BrandState> {
  final BrandRepository repository;

  BrandBloc({required this.repository}) : super(BrandInitial()) {
    on<LoadBrandsEvent>(_onLoad);
    on<SearchBrandsEvent>(_onSearch);
    on<LoadMoreBrandsEvent>(_onLoadMore);
  }

  FutureOr<void> _onLoad(
    LoadBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    emit(BrandLoading());
    try {
      final result = await repository.getBrands(event.filter);
      emit(
        BrandLoaded(
          brands: result.brands,
          count: result.count,
          filter: event.filter,
          hasMore: result.brands.length < result.count,
        ),
      );
    } catch (e) {
      emit(BrandError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onSearch(
    SearchBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    final filter = BrandFilter(search: event.search);
    emit(BrandLoading());
    try {
      final result = await repository.getBrands(filter);
      emit(
        BrandLoaded(
          brands: result.brands,
          count: result.count,
          filter: filter,
          hasMore: result.brands.length < result.count,
        ),
      );
    } catch (e) {
      emit(BrandError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLoadMore(
    LoadMoreBrandsEvent event,
    Emitter<BrandState> emit,
  ) async {
    final current = state;
    if (current is! BrandLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextFilter = current.filter.nextPage();
      final result = await repository.getBrands(nextFilter);
      emit(
        current.copyWith(
          brands: [...current.brands, ...result.brands],
          count: result.count,
          filter: nextFilter,
          isLoadingMore: false,
          hasMore: (current.brands.length + result.brands.length) < result.count,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}

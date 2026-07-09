import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/sizes/data/size_repository.dart';
import 'package:mbium_mobile_client/feature/sizes/models/size_filter.dart';
import 'package:mbium_mobile_client/feature/sizes/models/size_model.dart';

part 'size_event.dart';
part 'size_state.dart';

class SizeBloc extends Bloc<SizeEvent, SizeState> {
  final SizeRepository repository;

  SizeBloc({required this.repository}) : super(SizeInitial()) {
    on<LoadSizesEvent>(_onLoad);
    on<SearchSizesEvent>(_onSearch);
    on<LoadMoreSizesEvent>(_onLoadMore);
  }

  FutureOr<void> _onLoad(LoadSizesEvent event, Emitter<SizeState> emit) async {
    emit(SizeLoading());
    try {
      final result = await repository.getSizes(event.filter);
      emit(
        SizeLoaded(
          sizes: result.sizes,
          count: result.count,
          filter: event.filter,
          hasMore: result.sizes.length < result.count,
        ),
      );
    } catch (e) {
      emit(SizeError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onSearch(
    SearchSizesEvent event,
    Emitter<SizeState> emit,
  ) async {
    final filter = SizeFilter(search: event.search);
    emit(SizeLoading());
    try {
      final result = await repository.getSizes(filter);
      emit(
        SizeLoaded(
          sizes: result.sizes,
          count: result.count,
          filter: filter,
          hasMore: result.sizes.length < result.count,
        ),
      );
    } catch (e) {
      emit(SizeError(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _onLoadMore(
    LoadMoreSizesEvent event,
    Emitter<SizeState> emit,
  ) async {
    final current = state;
    if (current is! SizeLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    try {
      final nextFilter = current.filter.nextPage();
      final result = await repository.getSizes(nextFilter);
      emit(
        current.copyWith(
          sizes: [...current.sizes, ...result.sizes],
          count: result.count,
          filter: nextFilter,
          isLoadingMore: false,
          hasMore: (current.sizes.length + result.sizes.length) < result.count,
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }
}

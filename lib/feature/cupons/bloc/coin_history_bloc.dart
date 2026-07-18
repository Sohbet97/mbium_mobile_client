import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/cupons/data/coin_repository.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_history_model.dart';
import 'package:mbium_mobile_client/feature/cupons/models/coin_topup_model.dart';

part 'coin_history_event.dart';
part 'coin_history_state.dart';

class CoinHistoryBloc extends Bloc<CoinHistoryEvent, CoinHistoryState> {
  final CoinRepository repository;
  static const _limit = 30;

  CoinHistoryBloc({required this.repository}) : super(CoinHistoryInitial()) {
    on<LoadCoinHistoryEvent>(_onLoadHistory);
    on<LoadMoreCoinHistoryEvent>(_onLoadMoreHistory);
    on<LoadCoinTopupsEvent>(_onLoadTopups);
    on<LoadMoreCoinTopupsEvent>(_onLoadMoreTopups);
    on<SubmitCoinTopupEvent>(_onSubmitTopup);
  }

  Future<void> _onLoadHistory(
    LoadCoinHistoryEvent event,
    Emitter<CoinHistoryState> emit,
  ) async {
    emit(CoinHistoryLoading());
    try {
      final result = await repository.getHistory(page: 1, limit: _limit);
      emit(
        CoinHistoryLoaded(
          items: result.items,
          count: result.count,
          page: 1,
          hasMore: result.items.length < result.count,
        ),
      );
    } catch (e) {
      emit(CoinHistoryError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreHistory(
    LoadMoreCoinHistoryEvent event,
    Emitter<CoinHistoryState> emit,
  ) async {
    final current = state;
    if (current is! CoinHistoryLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.page + 1;
      final result = await repository.getHistory(
        page: nextPage,
        limit: _limit,
      );
      final items = [...current.items, ...result.items];
      emit(
        current.copyWith(
          items: items,
          count: result.count,
          page: nextPage,
          isLoadingMore: false,
          hasMore: items.length < result.count,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onLoadTopups(
    LoadCoinTopupsEvent event,
    Emitter<CoinHistoryState> emit,
  ) async {
    emit(CoinTopupsLoading());
    try {
      final result = await repository.getTopupRequests(page: 1, limit: _limit);
      emit(
        CoinTopupsLoaded(
          items: result.items,
          count: result.count,
          page: 1,
          hasMore: result.items.length < result.count,
        ),
      );
    } catch (e) {
      emit(CoinTopupsError(message: e.toString()));
    }
  }

  Future<void> _onLoadMoreTopups(
    LoadMoreCoinTopupsEvent event,
    Emitter<CoinHistoryState> emit,
  ) async {
    final current = state;
    if (current is! CoinTopupsLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.page + 1;
      final result = await repository.getTopupRequests(
        page: nextPage,
        limit: _limit,
      );
      final items = [...current.items, ...result.items];
      emit(
        current.copyWith(
          items: items,
          count: result.count,
          page: nextPage,
          isLoadingMore: false,
          hasMore: items.length < result.count,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> _onSubmitTopup(
    SubmitCoinTopupEvent event,
    Emitter<CoinHistoryState> emit,
  ) async {
    emit(CoinTopupSubmitting());
    try {
      final result = await repository.requestTopup(
        amountTmt: event.amountTmt,
        receiptUrl: event.receiptUrl,
      );
      emit(CoinTopupSubmitSuccess(topup: result));
    } catch (e) {
      emit(CoinTopupSubmitError(message: e.toString()));
    }
  }
}

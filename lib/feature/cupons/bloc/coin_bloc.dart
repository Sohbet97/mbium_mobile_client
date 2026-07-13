import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/cupons/data/coin_repository.dart';
import 'package:mbium_mobile_client/feature/cupons/models/my_coin_model.dart';

part 'coin_event.dart';
part 'coin_state.dart';

class CoinBloc extends Bloc<CoinEvent, CoinState> {
  final CoinRepository repository;

  CoinBloc({required this.repository}) : super(CoinInitial()) {
    on<LoadCoinBalanceEvent>(_onLoad);
  }

  FutureOr<void> _onLoad(
    LoadCoinBalanceEvent event,
    Emitter<CoinState> emit,
  ) async {
    emit(CoinLoading());
    try {
      final result = await repository.getBalance();
      emit(CoinLoaded(coin: result));
    } catch (e) {
      emit(CoinError(errorMessage: e.toString()));
    }
  }
}

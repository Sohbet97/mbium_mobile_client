part of 'coin_bloc.dart';

sealed class CoinEvent extends Equatable {
  const CoinEvent();

  @override
  List<Object> get props => [];
}

final class LoadCoinBalanceEvent extends CoinEvent {}

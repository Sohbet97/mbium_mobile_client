part of 'coin_bloc.dart';

sealed class CoinState extends Equatable {
  const CoinState();

  @override
  List<Object> get props => [];
}

final class CoinInitial extends CoinState {}

final class CoinLoading extends CoinState {}

final class CoinError extends CoinState {
  final String errorMessage;

  const CoinError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class CoinLoaded extends CoinState {
  final MyCoinModel coin;

  const CoinLoaded({required this.coin});

  @override
  List<Object> get props => [coin];
}

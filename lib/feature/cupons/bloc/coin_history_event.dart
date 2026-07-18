part of 'coin_history_bloc.dart';

sealed class CoinHistoryEvent extends Equatable {
  const CoinHistoryEvent();

  @override
  List<Object?> get props => [];
}

final class LoadCoinHistoryEvent extends CoinHistoryEvent {
  const LoadCoinHistoryEvent();
}

final class LoadMoreCoinHistoryEvent extends CoinHistoryEvent {
  const LoadMoreCoinHistoryEvent();
}

final class LoadCoinTopupsEvent extends CoinHistoryEvent {
  const LoadCoinTopupsEvent();
}

final class LoadMoreCoinTopupsEvent extends CoinHistoryEvent {
  const LoadMoreCoinTopupsEvent();
}

final class SubmitCoinTopupEvent extends CoinHistoryEvent {
  final double amountTmt;
  final String? receiptUrl;

  const SubmitCoinTopupEvent({required this.amountTmt, this.receiptUrl});

  @override
  List<Object?> get props => [amountTmt, receiptUrl];
}

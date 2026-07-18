part of 'coin_history_bloc.dart';

sealed class CoinHistoryState extends Equatable {
  const CoinHistoryState();

  @override
  List<Object?> get props => [];
}

final class CoinHistoryInitial extends CoinHistoryState {}

final class CoinHistoryLoading extends CoinHistoryState {}

final class CoinHistoryLoaded extends CoinHistoryState {
  final List<CoinHistoryModel> items;
  final int count;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const CoinHistoryLoaded({
    required this.items,
    required this.count,
    required this.page,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  CoinHistoryLoaded copyWith({
    List<CoinHistoryModel>? items,
    int? count,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CoinHistoryLoaded(
      items: items ?? this.items,
      count: count ?? this.count,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [items, count, page, hasMore, isLoadingMore];
}

final class CoinHistoryError extends CoinHistoryState {
  final String message;

  const CoinHistoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CoinTopupsLoading extends CoinHistoryState {}

final class CoinTopupsLoaded extends CoinHistoryState {
  final List<CoinTopupModel> items;
  final int count;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;

  const CoinTopupsLoaded({
    required this.items,
    required this.count,
    required this.page,
    this.hasMore = false,
    this.isLoadingMore = false,
  });

  CoinTopupsLoaded copyWith({
    List<CoinTopupModel>? items,
    int? count,
    int? page,
    bool? hasMore,
    bool? isLoadingMore,
  }) {
    return CoinTopupsLoaded(
      items: items ?? this.items,
      count: count ?? this.count,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [items, count, page, hasMore, isLoadingMore];
}

final class CoinTopupsError extends CoinHistoryState {
  final String message;

  const CoinTopupsError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class CoinTopupSubmitting extends CoinHistoryState {}

final class CoinTopupSubmitSuccess extends CoinHistoryState {
  final CoinTopupModel topup;

  const CoinTopupSubmitSuccess({required this.topup});

  @override
  List<Object?> get props => [topup];
}

final class CoinTopupSubmitError extends CoinHistoryState {
  final String message;

  const CoinTopupSubmitError({required this.message});

  @override
  List<Object?> get props => [message];
}

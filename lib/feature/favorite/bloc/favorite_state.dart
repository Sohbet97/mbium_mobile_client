part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoading extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> favorites;
  final int count;
  final int skip;
  final bool hasMore;
  final bool isLoadingMore;
  final Set<int> syncingProductIds;

  const FavoriteLoaded({
    required this.favorites,
    this.count = 0,
    this.skip = 0,
    this.hasMore = false,
    this.isLoadingMore = false,
    this.syncingProductIds = const {},
  });

  bool isFavorite(int productId) => favorites.any((p) => p.id == productId);

  bool isSyncing(int productId) => syncingProductIds.contains(productId);

  FavoriteLoaded copyWith({
    List<ProductModel>? favorites,
    int? count,
    int? skip,
    bool? hasMore,
    bool? isLoadingMore,
    Set<int>? syncingProductIds,
  }) {
    return FavoriteLoaded(
      favorites: favorites ?? this.favorites,
      count: count ?? this.count,
      skip: skip ?? this.skip,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      syncingProductIds: syncingProductIds ?? this.syncingProductIds,
    );
  }

  @override
  List<Object> get props => [
    favorites,
    count,
    skip,
    hasMore,
    isLoadingMore,
    syncingProductIds,
  ];
}

final class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError({required this.message});

  @override
  List<Object> get props => [message];
}

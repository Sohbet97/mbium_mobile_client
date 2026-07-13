part of 'shop_favorite_bloc.dart';

sealed class ShopFavoriteState extends Equatable {
  const ShopFavoriteState();
  @override
  List<Object> get props => [];
}

final class ShopFavoriteInitial extends ShopFavoriteState {}

final class ShopFavoriteLoaded extends ShopFavoriteState {
  final List<ShopDetailModel> favorites;

  const ShopFavoriteLoaded(this.favorites);

  bool isFavorite(int? shopId) =>
      shopId != null && favorites.any((s) => s.id == shopId);

  @override
  List<Object> get props => [favorites];
}

part of 'shop_favorite_bloc.dart';

sealed class ShopFavoriteEvent extends Equatable {
  const ShopFavoriteEvent();

  @override
  List<Object> get props => [];
}

final class LoadShopFavorites extends ShopFavoriteEvent {
  const LoadShopFavorites();
}

final class AddFavoriteShop extends ShopFavoriteEvent {
  final ShopDetailModel shop;

  const AddFavoriteShop(this.shop);

  @override
  List<Object> get props => [shop.id ?? 0];
}

final class RemoveFavoriteShop extends ShopFavoriteEvent {
  final int shopId;

  const RemoveFavoriteShop(this.shopId);

  @override
  List<Object> get props => [shopId];
}

final class ToggleFavoriteShop extends ShopFavoriteEvent {
  final ShopDetailModel shop;

  const ToggleFavoriteShop(this.shop);

  @override
  List<Object> get props => [shop.id ?? 0];
}

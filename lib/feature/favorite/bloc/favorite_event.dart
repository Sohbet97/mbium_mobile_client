part of 'favorite_bloc.dart';

sealed class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

final class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
}

final class LoadMoreFavorites extends FavoriteEvent {
  const LoadMoreFavorites();
}

final class AddFavoriteProduct extends FavoriteEvent {
  final ProductModel product;

  const AddFavoriteProduct(this.product);

  @override
  List<Object> get props => [product.id];
}

final class RemoveFavoriteProduct extends FavoriteEvent {
  final int productId;

  const RemoveFavoriteProduct(this.productId);

  @override
  List<Object> get props => [productId];
}

final class ToggleFavoriteProduct extends FavoriteEvent {
  final ProductModel product;

  const ToggleFavoriteProduct(this.product);

  @override
  List<Object> get props => [product.id];
}

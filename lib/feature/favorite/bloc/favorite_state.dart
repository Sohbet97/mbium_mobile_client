part of 'favorite_bloc.dart';

sealed class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

final class FavoriteInitial extends FavoriteState {}

final class FavoriteLoaded extends FavoriteState {
  final List<ProductModel> favorites;

  const FavoriteLoaded(this.favorites);

  bool isFavorite(int productId) => favorites.any((p) => p.id == productId);

  @override
  List<Object> get props => [favorites];
}

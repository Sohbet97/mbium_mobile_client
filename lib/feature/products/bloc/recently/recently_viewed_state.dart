part of 'recently_viewed_bloc.dart';

sealed class RecentlyViewedState extends Equatable {
  const RecentlyViewedState();

  @override
  List<Object?> get props => [];
}

final class RecentlyViewedLoaded extends RecentlyViewedState {
  final List<ProductModel> products;

  const RecentlyViewedLoaded(this.products);

  @override
  List<Object?> get props => [products];
}

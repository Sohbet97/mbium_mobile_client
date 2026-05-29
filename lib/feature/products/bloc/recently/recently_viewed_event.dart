part of 'recently_viewed_bloc.dart';

sealed class RecentlyViewedEvent extends Equatable {
  const RecentlyViewedEvent();

  @override
  List<Object?> get props => [];
}

final class LoadRecentlyViewed extends RecentlyViewedEvent {
  const LoadRecentlyViewed();
}

final class AddRecentlyViewed extends RecentlyViewedEvent {
  final ProductModel product;

  const AddRecentlyViewed(this.product);

  @override
  List<Object?> get props => [product.id];
}

final class ClearRecentlyViewed extends RecentlyViewedEvent {
  const ClearRecentlyViewed();
}

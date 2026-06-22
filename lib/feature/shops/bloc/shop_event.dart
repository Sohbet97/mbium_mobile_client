part of 'shop_bloc.dart';

sealed class ShopEvent extends Equatable {
  const ShopEvent();

  @override
  List<Object?> get props => [];
}

final class LoadShops extends ShopEvent {
  final ShopFilterModel filter;

  const LoadShops(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class LoadMoreShops extends ShopEvent {
  const LoadMoreShops();
}

final class RefreshShops extends ShopEvent {
  const RefreshShops();
}

final class GetShopDetailDataEvent extends ShopEvent {
  final int shopId;

  const GetShopDetailDataEvent({required this.shopId});
}

final class GetShopTypesEvent extends ShopEvent {
  const GetShopTypesEvent();
}

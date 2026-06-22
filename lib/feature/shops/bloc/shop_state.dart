part of 'shop_bloc.dart';

sealed class ShopState extends Equatable {
  const ShopState();

  @override
  List<Object?> get props => [];
}

final class ShopInitial extends ShopState {}

final class ShopLoading extends ShopState {}

final class ShopLoaded extends ShopState {
  final List<ShopModel> shops;
  final bool hasMore;
  final bool isLoadingMore;
  final ShopFilterModel filter;

  const ShopLoaded({
    required this.shops,
    required this.hasMore,
    required this.filter,
    this.isLoadingMore = false,
  });

  ShopLoaded copyWith({
    List<ShopModel>? shops,
    bool? hasMore,
    bool? isLoadingMore,
    ShopFilterModel? filter,
  }) {
    return ShopLoaded(
      shops: shops ?? this.shops,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [shops, hasMore, isLoadingMore, filter];
}

final class ShopError extends ShopState {
  final String message;
  final ShopFilterModel? filter;

  const ShopError({required this.message, this.filter});

  @override
  List<Object?> get props => [message, filter];
}

final class GetDetailShopDataError extends ShopState {
  final String message;

  const GetDetailShopDataError({required this.message});
}

final class GetDetailShopDataProgress extends ShopState {}

final class GetDetailShopDataSuccess extends ShopState {
  final ShopDetailModel response;

  const GetDetailShopDataSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

final class GetShopTypesError extends ShopState {
  final String message;

  const GetShopTypesError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class GetShopTypesProgress extends ShopState {}

final class GetShopTypesSuccess extends ShopState {
  final List<ShopTypeModel> shopTypes;

  const GetShopTypesSuccess({required this.shopTypes});

  @override
  List<Object?> get props => [shopTypes];
}

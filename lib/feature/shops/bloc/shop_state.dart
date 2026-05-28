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

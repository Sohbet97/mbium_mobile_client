part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final List<ProductModel> products;
  final bool hasMore;
  final bool isLoadingMore;
  final FilterModel filter;

  const ProductLoaded({
    required this.products,
    required this.hasMore,
    required this.filter,
    this.isLoadingMore = false,
  });

  ProductLoaded copyWith({
    List<ProductModel>? products,
    bool? hasMore,
    bool? isLoadingMore,
    FilterModel? filter,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [products, hasMore, isLoadingMore, filter];
}

final class ProductError extends ProductState {
  final String message;
  final FilterModel? filter;

  const ProductError({required this.message, this.filter});

  @override
  List<Object?> get props => [message];
}

final class GetProductDetailProgress extends ProductState {}

final class GetProductDetailError extends ProductState {
  final String errorMessage;

  const GetProductDetailError({required this.errorMessage});
}

final class GetProductDetailSuccess extends ProductState {
  final ProductDetailModel detailModel;

  const GetProductDetailSuccess({required this.detailModel});

  @override
  List<Object?> get props => [detailModel];
}

part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

final class LoadProducts extends ProductEvent {
  final FilterModel filter;

  const LoadProducts(this.filter);

  @override
  List<Object?> get props => [filter];
}

final class LoadMoreProducts extends ProductEvent {
  const LoadMoreProducts();
}

final class RefreshProducts extends ProductEvent {
  const RefreshProducts();
}

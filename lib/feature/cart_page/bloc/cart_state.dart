part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> items;
  final Set<int> syncingProductIds;

  const CartLoaded({
    required this.items,
    this.syncingProductIds = const {},
  });

  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Quantity of the line matching this exact product+variant+size identity.
  /// Defaults to the plain (no-variant) line.
  int quantityOf(int productId, {int? variantId, int? variantSizeId}) {
    final index = items.indexWhere(
      (i) => i.matchesLine(productId, variantId, variantSizeId),
    );
    return index >= 0 ? items[index].quantity : 0;
  }

  /// Sum of quantities across every line of this product, regardless of
  /// variant — used where the caller can't disambiguate which variant line
  /// to mutate (e.g. a grid card with no variant context) but still needs to
  /// show "this product is in the cart".
  int totalQuantityOfProduct(int productId) => items
      .where((i) => i.product.id == productId)
      .fold(0, (sum, i) => sum + i.quantity);

  bool isSyncing(int productId) => syncingProductIds.contains(productId);

  CartLoaded copyWith({
    List<CartModel>? items,
    Set<int>? syncingProductIds,
  }) {
    return CartLoaded(
      items: items ?? this.items,
      syncingProductIds: syncingProductIds ?? this.syncingProductIds,
    );
  }

  @override
  List<Object> get props => [items, syncingProductIds];
}

class CartError extends CartState {
  final String message;

  const CartError({required this.message});

  @override
  List<Object> get props => [message];
}

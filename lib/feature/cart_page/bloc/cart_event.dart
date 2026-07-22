part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCartEvent extends CartEvent {
  const LoadCartEvent();
}

class AddToCartEvent extends CartEvent {
  final ProductModel product;
  final int? variantId;
  final int? variantSizeId;
  final String? variantLabel;

  /// Units to add on top of whatever quantity is already in the cart for
  /// this line (not an absolute value).
  final int quantity;

  const AddToCartEvent(
    this.product, {
    this.variantId,
    this.variantSizeId,
    this.variantLabel,
    this.quantity = 1,
  });

  @override
  List<Object> get props => [product.id, variantId ?? 0, variantSizeId ?? 0];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  final int? variantId;
  final int? variantSizeId;

  const RemoveFromCartEvent(this.productId, {this.variantId, this.variantSizeId});

  @override
  List<Object> get props => [productId, variantId ?? 0, variantSizeId ?? 0];
}

class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;
  final int? variantId;
  final int? variantSizeId;

  const UpdateQuantityEvent(
    this.productId,
    this.quantity, {
    this.variantId,
    this.variantSizeId,
  });

  @override
  List<Object> get props => [productId, quantity, variantId ?? 0, variantSizeId ?? 0];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

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
  const AddToCartEvent(this.product);

  @override
  List<Object> get props => [product.id];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;
  const RemoveFromCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;
  const UpdateQuantityEvent(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCartEvent extends CartEvent {
  const ClearCartEvent();
}

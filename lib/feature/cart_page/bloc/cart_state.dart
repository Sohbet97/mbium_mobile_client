part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartModel> items;
  final double totalPrice;

  const CartLoaded({required this.items, required this.totalPrice});

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  int quantityOf(int productId) {
    final index = items.indexWhere((i) => i.product.id == productId);
    return index >= 0 ? items[index].quantity : 0;
  }

  @override
  List<Object> get props => [items, totalPrice];
}

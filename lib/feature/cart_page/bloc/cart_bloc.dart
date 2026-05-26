import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/cart_page/data/cart_repository.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartInitial()) {
    on<LoadCartEvent>(_onLoad);
    on<AddToCartEvent>(_onAdd);
    on<RemoveFromCartEvent>(_onRemove);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
    on<ClearCartEvent>(_onClear);
  }

  void _emitLoaded(Emitter<CartState> emit) {
    emit(CartLoaded(
      items: repository.getCartItems(),
      totalPrice: repository.getTotalPrice(),
    ));
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    await repository.loadFromStorage();
    _emitLoaded(emit);
  }

  // All mutations are synchronous in-memory → instant state update.
  // Disk persistence happens in the background inside the repository.

  void _onAdd(AddToCartEvent event, Emitter<CartState> emit) {
    repository.addToCart(event.product);
    _emitLoaded(emit);
  }

  void _onRemove(RemoveFromCartEvent event, Emitter<CartState> emit) {
    repository.removeFromCart(event.productId);
    _emitLoaded(emit);
  }

  void _onUpdateQuantity(UpdateQuantityEvent event, Emitter<CartState> emit) {
    repository.updateQuantity(event.productId, event.quantity);
    _emitLoaded(emit);
  }

  void _onClear(ClearCartEvent event, Emitter<CartState> emit) {
    repository.clearCart();
    _emitLoaded(emit);
  }
}

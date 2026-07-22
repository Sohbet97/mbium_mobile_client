import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/core/network/interceptors.dart';
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

  CartLoaded _ensureLoaded() {
    final s = state;
    if (s is CartLoaded) return s;
    return const CartLoaded(items: []);
  }

  // CartApiException carries the backend's own `message` (e.g. "Ýeterlik
  // stok ýok (bar: 0)") — prefer that over the generic fallback whenever
  // it's present.
  String _errorMessage(Object error, String fallback) {
    if (error is CartApiException && error.serverMessage != null) {
      return error.serverMessage!;
    }
    return fallback;
  }

  Future<void> _onLoad(LoadCartEvent event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final items = await repository.getCart();
      emit(CartLoaded(items: items));
    } catch (e) {
      emit(CartError(message: e.toString()));
      showGlobalMessage(_errorMessage(e, 'Не удалось загрузить корзину'));
    }
  }

  void _setSyncing(int productId, bool value, Emitter<CartState> emit) {
    final s = state;
    if (s is! CartLoaded) return;
    final syncing = Set<int>.of(s.syncingProductIds);
    value ? syncing.add(productId) : syncing.remove(productId);
    emit(s.copyWith(syncingProductIds: syncing));
  }

  // Optimistic: local list is updated first so the UI reacts instantly, then
  // the server call runs in the background (syncingProductIds drives any
  // in-flight indicator). On failure the optimistic change is rolled back to
  // [rollbackItems] so the cart doesn't show e.g. a quantity the server
  // rejected for insufficient stock. successMessage is left null for
  // high-frequency actions (quantity +/-) to avoid a toast on every tap —
  // errors are always shown.
  Future<void> _syncUpsert(
    int productId,
    int quantity,
    Emitter<CartState> emit, {
    required List<CartModel> rollbackItems,
    int? variantId,
    int? variantSizeId,
    String? successMessage,
    required String errorMessage,
  }) async {
    _setSyncing(productId, true, emit);
    try {
      await repository.upsertItem(
        productId: productId,
        quantity: quantity,
        variantId: variantId,
        variantSizeId: variantSizeId,
      );
      if (successMessage != null) {
        showGlobalMessage(successMessage, isError: false);
      }
    } catch (e) {
      emit(_ensureLoaded().copyWith(items: rollbackItems));
      showGlobalMessage(_errorMessage(e, errorMessage));
    } finally {
      _setSyncing(productId, false, emit);
    }
  }

  // Cart lines are keyed by (productId, variantId, variantSizeId) — the same
  // product can have several lines in the cart for different variants, so a
  // plain productId match isn't enough once variants are involved.
  Future<void> _onAdd(AddToCartEvent event, Emitter<CartState> emit) async {
    final current = _ensureLoaded();
    final index = current.items.indexWhere(
      (i) => i.matchesLine(
        event.product.id,
        event.variantId,
        event.variantSizeId,
      ),
    );
    final items = [...current.items];
    final int newQuantity;
    if (index >= 0) {
      newQuantity = items[index].quantity + event.quantity;
      items[index] = items[index].copyWith(quantity: newQuantity);
    } else {
      newQuantity = event.quantity;
      items.add(
        CartModel(
          product: event.product,
          quantity: newQuantity,
          addedAt: DateTime.now(),
          variantId: event.variantId,
          variantSizeId: event.variantSizeId,
          variantLabel: event.variantLabel,
        ),
      );
    }
    emit(current.copyWith(items: items));
    await _syncUpsert(
      event.product.id,
      newQuantity,
      emit,
      rollbackItems: current.items,
      variantId: event.variantId,
      variantSizeId: event.variantSizeId,
      successMessage: 'Товар добавлен в корзину',
      errorMessage: 'Не удалось добавить товар в корзину',
    );
  }

  Future<void> _onRemove(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final current = _ensureLoaded();
    final items = current.items
        .where(
          (i) => !i.matchesLine(
            event.productId,
            event.variantId,
            event.variantSizeId,
          ),
        )
        .toList();
    emit(current.copyWith(items: items));
    _setSyncing(event.productId, true, emit);
    try {
      await repository.removeItem(event.productId);
      showGlobalMessage('Товар удалён из корзины', isError: false);
    } catch (e) {
      emit(_ensureLoaded().copyWith(items: current.items));
      showGlobalMessage(_errorMessage(e, 'Не удалось удалить товар из корзины'));
    } finally {
      _setSyncing(event.productId, false, emit);
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    if (event.quantity <= 0) {
      await _onRemove(
        RemoveFromCartEvent(
          event.productId,
          variantId: event.variantId,
          variantSizeId: event.variantSizeId,
        ),
        emit,
      );
      return;
    }
    final current = _ensureLoaded();
    final items = current.items
        .map(
          (i) => i.matchesLine(
            event.productId,
            event.variantId,
            event.variantSizeId,
          )
              ? i.copyWith(quantity: event.quantity)
              : i,
        )
        .toList();
    emit(current.copyWith(items: items));
    await _syncUpsert(
      event.productId,
      event.quantity,
      emit,
      rollbackItems: current.items,
      variantId: event.variantId,
      variantSizeId: event.variantSizeId,
      errorMessage: 'Не удалось обновить количество товара',
    );
  }

  Future<void> _onClear(ClearCartEvent event, Emitter<CartState> emit) async {
    final current = _ensureLoaded();
    emit(const CartLoaded(items: []));
    try {
      await repository.clearCart();
      showGlobalMessage('Корзина очищена', isError: false);
    } catch (e) {
      emit(current);
      showGlobalMessage(_errorMessage(e, 'Не удалось очистить корзину'));
    }
  }
}

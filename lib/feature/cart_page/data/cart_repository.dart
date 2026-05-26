import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/cart_page/models/cart_model.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

class CartRepository {
  final Dio dio;
  final AppPreferences appPreferences;

  CartRepository({required this.dio, required this.appPreferences});

  static const _cartKey = 'cart_items';

  List<CartModel> _cartItems = [];

  // ── Read ──────────────────────────────────────────────────────────────────

  List<CartModel> getCartItems() => List.unmodifiable(_cartItems);

  double getTotalPrice() =>
      _cartItems.fold(0, (sum, i) => sum + i.product.price * i.quantity);

  int getItemCount() => _cartItems.fold(0, (sum, i) => sum + i.quantity);

  int getQuantityFor(int productId) {
    final index = _cartItems.indexWhere((i) => i.product.id == productId);
    return index >= 0 ? _cartItems[index].quantity : 0;
  }

  // ── Persistence ───────────────────────────────────────────────────────────

  Future<void> loadFromStorage() async {
    final raw = appPreferences.getString(_cartKey);
    if (raw == null) return;
    try {
      final List<dynamic> list = jsonDecode(raw);
      _cartItems = list.map((e) => CartModel.fromJson(e)).toList();
    } catch (_) {
      _cartItems = [];
    }
  }

  // Fire-and-forget: memory is already updated, disk write happens in background.
  void _persistAsync() {
    final encoded = jsonEncode(_cartItems.map((e) => e.toJson()).toList());
    appPreferences.setString(_cartKey, encoded);
  }

  // ── Mutations (synchronous in-memory, async disk) ─────────────────────────

  void addToCart(ProductModel product) {
    final index = _cartItems.indexWhere((i) => i.product.id == product.id);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
    } else {
      _cartItems.add(
        CartModel(product: product, quantity: 1, addedAt: DateTime.now()),
      );
    }
    _persistAsync();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((i) => i.product.id == productId);
    _persistAsync();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    final index = _cartItems.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      _persistAsync();
    }
  }

  void clearCart() {
    _cartItems = [];
    _persistAsync();
  }
}

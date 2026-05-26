import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  static const _favoritesKey = 'favorite_products';

  FavoriteBloc() : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddFavoriteProduct>(_onAddFavorite);
    on<RemoveFavoriteProduct>(_onRemoveFavorite);
    on<ToggleFavoriteProduct>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_favoritesKey) ?? [];
    final products = jsonList
        .map(
          (e) => ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
    emit(FavoriteLoaded(products));
  }

  Future<void> _onAddFavorite(
    AddFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = _currentFavorites();
    if (current.any((p) => p.id == event.product.id)) return;
    final updated = [...current, event.product];
    await _persist(updated);
    emit(FavoriteLoaded(updated));
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final updated = _currentFavorites()
        .where((p) => p.id != event.productId)
        .toList();
    await _persist(updated);
    emit(FavoriteLoaded(updated));
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = _currentFavorites();
    final List<ProductModel> updated;
    if (current.any((p) => p.id == event.product.id)) {
      updated = current.where((p) => p.id != event.product.id).toList();
    } else {
      updated = [...current, event.product];
    }
    await _persist(updated);
    emit(FavoriteLoaded(updated));
  }

  List<ProductModel> _currentFavorites() {
    final s = state;
    return s is FavoriteLoaded ? s.favorites : [];
  }

  Future<void> _persist(List<ProductModel> products) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = products.map((p) => jsonEncode(p.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonList);
  }
}

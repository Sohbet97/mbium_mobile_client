import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final AppPreferences appPreferences;

  static const _favoritesKey = 'favorite_products';

  FavoriteBloc({required this.appPreferences}) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoad);
    on<AddFavoriteProduct>(_onAdd);
    on<RemoveFavoriteProduct>(_onRemove);
    on<ToggleFavoriteProduct>(_onToggle);
  }

  List<ProductModel> _currentFavorites() {
    final s = state;
    return s is FavoriteLoaded ? List.of(s.favorites) : [];
  }

  // Fire-and-forget disk write.
  void _persistAsync(List<ProductModel> products) {
    final jsonList = products.map((p) => jsonEncode(p.toJson())).toList();
    appPreferences.setStringList(_favoritesKey, jsonList);
  }

  Future<void> _onLoad(LoadFavorites event, Emitter<FavoriteState> emit) async {
    final jsonList = appPreferences.getStringList(_favoritesKey) ?? [];
    final products = jsonList
        .map((e) => ProductModel.fromJson(jsonDecode(e) as Map<String, dynamic>))
        .toList();
    emit(FavoriteLoaded(products));
  }

  // All mutations: update in-memory → emit instantly → persist in background.

  void _onAdd(AddFavoriteProduct event, Emitter<FavoriteState> emit) {
    final current = _currentFavorites();
    if (current.any((p) => p.id == event.product.id)) return;
    final updated = [...current, event.product];
    emit(FavoriteLoaded(updated));
    _persistAsync(updated);
  }

  void _onRemove(RemoveFavoriteProduct event, Emitter<FavoriteState> emit) {
    final updated = _currentFavorites()
        .where((p) => p.id != event.productId)
        .toList();
    emit(FavoriteLoaded(updated));
    _persistAsync(updated);
  }

  void _onToggle(ToggleFavoriteProduct event, Emitter<FavoriteState> emit) {
    final current = _currentFavorites();
    final List<ProductModel> updated;
    if (current.any((p) => p.id == event.product.id)) {
      updated = current.where((p) => p.id != event.product.id).toList();
    } else {
      updated = [...current, event.product];
    }
    emit(FavoriteLoaded(updated));
    _persistAsync(updated);
  }
}

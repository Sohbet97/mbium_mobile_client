import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/core/storage/app_preferences.dart';
import 'package:mbium_mobile_client/feature/shops/model/shop_detail_model.dart';

part 'shop_favorite_event.dart';
part 'shop_favorite_state.dart';

class ShopFavoriteBloc extends Bloc<ShopFavoriteEvent, ShopFavoriteState> {
  final AppPreferences appPreferences;

  static const _favoritesKey = 'favorite_shops';

  ShopFavoriteBloc({required this.appPreferences})
    : super(ShopFavoriteInitial()) {
    on<LoadShopFavorites>(_onLoad);
    on<AddFavoriteShop>(_onAdd);
    on<RemoveFavoriteShop>(_onRemove);
    on<ToggleFavoriteShop>(_onToggle);
  }

  List<ShopDetailModel> _currentFavorites() {
    final s = state;
    return s is ShopFavoriteLoaded ? List.of(s.favorites) : [];
  }

  // Fire-and-forget disk write.
  void _persistAsync(List<ShopDetailModel> shops) {
    final jsonList = shops.map((s) => jsonEncode(s.toJson())).toList();
    appPreferences.setStringList(_favoritesKey, jsonList);
  }

  Future<void> _onLoad(
    LoadShopFavorites event,
    Emitter<ShopFavoriteState> emit,
  ) async {
    final jsonList = appPreferences.getStringList(_favoritesKey) ?? [];
    final shops = jsonList
        .map(
          (e) =>
              ShopDetailModel.fromJson(jsonDecode(e) as Map<String, dynamic>),
        )
        .toList();
    emit(ShopFavoriteLoaded(shops));
  }

  // All mutations: update in-memory → emit instantly → persist in background.

  void _onAdd(AddFavoriteShop event, Emitter<ShopFavoriteState> emit) {
    final current = _currentFavorites();
    if (current.any((s) => s.id == event.shop.id)) return;
    final updated = [...current, event.shop];
    emit(ShopFavoriteLoaded(updated));
    _persistAsync(updated);
  }

  void _onRemove(RemoveFavoriteShop event, Emitter<ShopFavoriteState> emit) {
    final updated = _currentFavorites()
        .where((s) => s.id != event.shopId)
        .toList();
    emit(ShopFavoriteLoaded(updated));
    _persistAsync(updated);
  }

  void _onToggle(ToggleFavoriteShop event, Emitter<ShopFavoriteState> emit) {
    final current = _currentFavorites();
    final List<ShopDetailModel> updated;
    if (current.any((s) => s.id == event.shop.id)) {
      updated = current.where((s) => s.id != event.shop.id).toList();
    } else {
      updated = [...current, event.shop];
    }
    emit(ShopFavoriteLoaded(updated));
    _persistAsync(updated);
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/favorite/data/favorite_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;
  static const _limit = 30;

  FavoriteBloc({required this.repository}) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoad);
    on<LoadMoreFavorites>(_onLoadMore);
    on<AddFavoriteProduct>(_onAdd);
    on<RemoveFavoriteProduct>(_onRemove);
    on<ToggleFavoriteProduct>(_onToggle);
  }

  FavoriteLoaded _ensureLoaded() {
    final s = state;
    if (s is FavoriteLoaded) return s;
    return const FavoriteLoaded(favorites: []);
  }

  Future<void> _onLoad(LoadFavorites event, Emitter<FavoriteState> emit) async {
    emit(FavoriteLoading());
    try {
      final result = await repository.getFavorites(limit: _limit, skip: 0);
      emit(
        FavoriteLoaded(
          favorites: result.items,
          count: result.count,
          skip: 0,
          hasMore: result.items.length < result.count,
        ),
      );
    } catch (e) {
      emit(FavoriteError(message: e.toString()));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = state;
    if (current is! FavoriteLoaded ||
        !current.hasMore ||
        current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextSkip = current.skip + _limit;
      final result = await repository.getFavorites(
        limit: _limit,
        skip: nextSkip,
      );
      final favorites = [...current.favorites, ...result.items];
      emit(
        current.copyWith(
          favorites: favorites,
          count: result.count,
          skip: nextSkip,
          isLoadingMore: false,
          hasMore: favorites.length < result.count,
        ),
      );
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  // Best-effort server sync; local state is updated optimistically first so
  // the star toggles instantly, then syncingProductIds drives the progress
  // indicator in FavoriteItemWidget while the request is in flight.
  Future<void> _syncAdd(int productId, Emitter<FavoriteState> emit) async {
    _setSyncing(productId, true, emit);
    try {
      await repository.addFavorite(productId);
    } catch (_) {
    } finally {
      _setSyncing(productId, false, emit);
    }
  }

  Future<void> _syncRemove(int productId, Emitter<FavoriteState> emit) async {
    _setSyncing(productId, true, emit);
    try {
      await repository.removeFavorite(productId);
    } catch (_) {
    } finally {
      _setSyncing(productId, false, emit);
    }
  }

  void _setSyncing(int productId, bool value, Emitter<FavoriteState> emit) {
    final s = state;
    if (s is! FavoriteLoaded) return;
    final syncing = Set<int>.of(s.syncingProductIds);
    value ? syncing.add(productId) : syncing.remove(productId);
    emit(s.copyWith(syncingProductIds: syncing));
  }

  Future<void> _onAdd(
    AddFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = _ensureLoaded();
    if (current.isFavorite(event.product.id)) return;
    emit(
      current.copyWith(
        favorites: [...current.favorites, event.product],
        count: current.count + 1,
      ),
    );
    await _syncAdd(event.product.id, emit);
  }

  Future<void> _onRemove(
    RemoveFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = _ensureLoaded();
    emit(
      current.copyWith(
        favorites: current.favorites
            .where((p) => p.id != event.productId)
            .toList(),
        count: current.count > 0 ? current.count - 1 : 0,
      ),
    );
    await _syncRemove(event.productId, emit);
  }

  Future<void> _onToggle(
    ToggleFavoriteProduct event,
    Emitter<FavoriteState> emit,
  ) async {
    final current = _ensureLoaded();
    final isAdding = !current.isFavorite(event.product.id);
    final favorites = isAdding
        ? [...current.favorites, event.product]
        : current.favorites.where((p) => p.id != event.product.id).toList();
    emit(
      current.copyWith(
        favorites: favorites,
        count: isAdding
            ? current.count + 1
            : (current.count > 0 ? current.count - 1 : 0),
      ),
    );
    if (isAdding) {
      await _syncAdd(event.product.id, emit);
    } else {
      await _syncRemove(event.product.id, emit);
    }
  }
}

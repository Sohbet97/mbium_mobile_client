import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/products/data/recently_viewed_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

part 'recently_viewed_event.dart';
part 'recently_viewed_state.dart';

class RecentlyViewedBloc
    extends Bloc<RecentlyViewedEvent, RecentlyViewedState> {
  final RecentlyViewedRepository repository;

  RecentlyViewedBloc({required this.repository})
      : super(const RecentlyViewedLoaded([])) {
    on<LoadRecentlyViewed>(_onLoad);
    on<AddRecentlyViewed>(_onAdd);
    on<ClearRecentlyViewed>(_onClear);
  }

  void _onLoad(LoadRecentlyViewed event, Emitter<RecentlyViewedState> emit) {
    final products = repository.load();
    emit(RecentlyViewedLoaded(products));
  }

  Future<void> _onAdd(
    AddRecentlyViewed event,
    Emitter<RecentlyViewedState> emit,
  ) async {
    final products = await repository.add(event.product);
    emit(RecentlyViewedLoaded(products));
  }

  Future<void> _onClear(
    ClearRecentlyViewed event,
    Emitter<RecentlyViewedState> emit,
  ) async {
    await repository.clear();
    emit(const RecentlyViewedLoaded([]));
  }
}

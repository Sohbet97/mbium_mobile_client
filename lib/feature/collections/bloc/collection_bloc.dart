import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_model.dart';
import 'package:mbium_mobile_client/feature/collections/data/collection_repository.dart';
import 'package:mbium_mobile_client/feature/products/models/product_model.dart';

part 'collection_event.dart';
part 'collection_state.dart';

class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final CollectionRepository repository;
  List<CollectionModel>? _collections;

  CollectionBloc({required this.repository}) : super(CollectionInitial()) {
    on<LoadAllCollectionEvent>(_onLoadAll);
    on<LoadCollectionProductsEvent>(_onLoadProducts);
  }

  Future<void> _onLoadAll(
    LoadAllCollectionEvent event,
    Emitter<CollectionState> emit,
  ) async {
    emit(LoadAllCollectionsProgress());

    if (_collections != null) {
      emit(LoadAllCollectionsSuccess(collections: _collections!));
      return;
    }

    try {
      _collections = await repository.getCollections();
      emit(LoadAllCollectionsSuccess(collections: _collections!));
    } catch (e) {
      emit(LoadAllCollectionsError(errorMessage: e.toString()));
    }
  }

  Future<void> _onLoadProducts(
    LoadCollectionProductsEvent event,
    Emitter<CollectionState> emit,
  ) async {
    final current = state;
    if (current is! LoadAllCollectionsSuccess) return;
    if (current.productsByCollection.containsKey(event.collectionId) ||
        current.loadingProductIds.contains(event.collectionId)) {
      return;
    }

    emit(
      current.copyWith(
        loadingProductIds: {...current.loadingProductIds, event.collectionId},
      ),
    );

    try {
      final products = await repository.getCollectionProducts(
        event.collectionId,
      );

      final latest = state;
      if (latest is! LoadAllCollectionsSuccess) return;
      emit(
        latest.copyWith(
          productsByCollection: {
            ...latest.productsByCollection,
            event.collectionId: products,
          },
          loadingProductIds: {...latest.loadingProductIds}
            ..remove(event.collectionId),
        ),
      );
    } catch (_) {
      final latest = state;
      if (latest is! LoadAllCollectionsSuccess) return;
      emit(
        latest.copyWith(
          loadingProductIds: {...latest.loadingProductIds}
            ..remove(event.collectionId),
        ),
      );
    }
  }
}

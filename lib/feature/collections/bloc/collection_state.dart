part of 'collection_bloc.dart';

sealed class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

final class CollectionInitial extends CollectionState {}

final class LoadAllCollectionsProgress extends CollectionState {}

final class LoadAllCollectionsError extends CollectionState {
  final String errorMessage;

  const LoadAllCollectionsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}

final class LoadAllCollectionsSuccess extends CollectionState {
  final List<CollectionModel> collections;
  final Map<int, List<ProductModel>> productsByCollection;
  final Set<int> loadingProductIds;

  const LoadAllCollectionsSuccess({
    required this.collections,
    this.productsByCollection = const {},
    this.loadingProductIds = const {},
  });

  LoadAllCollectionsSuccess copyWith({
    Map<int, List<ProductModel>>? productsByCollection,
    Set<int>? loadingProductIds,
  }) {
    return LoadAllCollectionsSuccess(
      collections: collections,
      productsByCollection: productsByCollection ?? this.productsByCollection,
      loadingProductIds: loadingProductIds ?? this.loadingProductIds,
    );
  }

  @override
  List<Object> get props => [collections, productsByCollection, loadingProductIds];
}

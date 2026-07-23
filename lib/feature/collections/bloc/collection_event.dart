part of 'collection_bloc.dart';

sealed class CollectionEvent extends Equatable {
  const CollectionEvent();

  @override
  List<Object> get props => [];
}

final class LoadAllCollectionEvent extends CollectionEvent {}

final class LoadCollectionProductsEvent extends CollectionEvent {
  final int collectionId;

  const LoadCollectionProductsEvent({required this.collectionId});

  @override
  List<Object> get props => [collectionId];
}

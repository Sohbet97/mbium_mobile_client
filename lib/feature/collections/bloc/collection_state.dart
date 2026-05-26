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

  const LoadAllCollectionsSuccess({required this.collections});

  @override
  List<Object> get props => [collections];
}

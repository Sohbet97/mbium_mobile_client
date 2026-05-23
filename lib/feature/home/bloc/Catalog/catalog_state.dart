part of 'catalog_bloc.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();
  
  @override
  List<Object> get props => [];
}

final class CatalogInitial extends CatalogState {}
